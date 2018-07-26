# r_cache.coffee, pdso/src/lib/core/

r_cache = (tab_id) ->
  # global data
  g = {
    # data report to parent (tab_list)
    rc: {
      tab_id
      # ever got reset after enable tab
      after_reset: false

      # all res record count
      count: 0
      # TODO completed res count ?  error res count ?
    }
    # callback to report to parent
    rc_callback: null

    # cache for all loaded resources
    cache: {  # this is info only
      #'R_ID': {  # R_ID: the request id
      #  r_id: ''  # request id is string
      #  error: false  # true if load error
      #  error_desc: ''  # description of this error
      #  res_start: false  # after onResponseStarted
      #  done: false  # true if response completed
      #
      #  url: []  # url list (including redirect) of this resource
      #
      #  method: ''
      #  type: ''
      #  frame_id: 0
      #  # TODO more info such as headers ?
      #}
    }
    cache_data: {  # this saves response data
      #'R_ID': []  # data chunks of this resource
    }
    # flags: stream filter installed
    sf_installed: {
      #'R_ID': false
    }
  }
  # report rc to parent
  _report = ->
    g.rc_callback?(tab_id, g.rc)

  set_rc_callback = (cb) ->
    g.rc_callback = cb
    _report()  # update data

  # cache operate

  # check r_id and create it if not exist
  _check_request = (details) ->
    {
      requestId: r_id
      url

      method
      type
      frameId
    } = details
    # check new request
    if ! g.cache[r_id]?
      # init info cache
      g.cache[r_id] = {
        r_id
        error: false
        error_desc: null
        res_start: false
        done: false

        url: [ url ]

        method
        type
        frame_id: frameId
      }
      # init data cache
      g.cache_data[r_id] = []
      # update count
      g.rc.count += 1

  # add url to the request if not exist
  _add_url = (r_id, url) ->
    # assert: g.cache[r_id] != null
    if g.cache[r_id].url.indexOf(url) is -1
      g.cache[r_id].url.push url

  # save resources response data
  _init_stream_filter = (r_id) ->
    f = browser.webRequest.filterResponseData r_id

    f.onstart = (event) ->
      # FIXME TODO reset cache_data each time when start ?

    f.ondata = (event) ->
      f.write(event.data)

    f.onstop = (event) ->
      f.disconnect()
      # TODO mark res data recv done ?

    f.onerror = (event) ->
      console.log "ERROR: r_cache.filter_stream, tab_id = #{tab_id}, r_id = #{r_id}\n#{f.error}"

  # webRequest event listeners
  _on_before_request = (details) ->
    {
      requestId: r_id
      tabId
      url
      #timeStamp

      #method
      #type
      #frameId
      #frameAncestors
      #documentUrl
      #originUrl
      #requestBody
    } = details
    # assert: tabId == tab_id
    _check_request details
    _add_url r_id, url
    # install stream filter
    if ! g.sf_installed[r_id]
      _init_stream_filter r_id
      g.sf_installed[r_id] = true

    _report()  # update data
    # return empty for blocking
    {}

  _on_before_redirect = (details) ->
    {
      requestId: r_id
      tabId
      redirectUrl
      #timeStamp

      statusCode
      statusLine
      responseHeaders
      fromCache
      ip
    } = details

  _on_before_send_headers = (details) ->
    {
      requestId: r_id
      tabId
      requestHeaders
      #timeStamp
    } = details

  _on_send_headers = (details) ->
    {
      requestId: r_id
      tabId
      requestHeaders
      #timeStamp
    } = details

  _on_headers_received = (details) ->
    {
      requestId: r_id
      tabId
      statusCode
      statusLine
      responseHeaders
      #timeStamp
    } = details

  _on_response_started = (details) ->
    {
      requestId: r_id
      tabId
      #timeStamp
      statusCode
      statusLine
      responseHeaders
      fromCache
      ip
    } = details
    # assert: g.cache[r_id] != null
    g.cache[r_id].res_start = true

  _on_completed = (details) ->
    {
      requestId: r_id
      tabId
      #timeStamp
      statusCode
      statusLine
      responseHeaders
      fromCache
      ip
    } = details
    # assert: g.cache[r_id] != null
    g.cache[r_id].done = true

  _on_error = (details) ->
    {
      requestId: r_id
      tabId
      error
      #timeStamp
      fromCache
      ip
    } = details
    # assert: g.cache[r_id] != null
    g.cache[r_id].error = true
    g.cache[r_id].error_desc = error

  # only listen events for this tab
  filter = {
    urls: [
      '<all_urls>'
    ]
    tabId: tab_id
  }

  init = ->
    browser.webRequest.onBeforeRequest.addListener _on_before_request, filter, [
      'blocking'  # block request for _init_stream_filter
      'requestBody'
    ]
    browser.webRequest.onBeforeRedirect.addListener _on_before_redirect, filter, [
      'responseHeaders'
    ]
    browser.webRequest.onBeforeSendHeaders.addListener _on_before_send_headers, filter, [
      'requestHeaders'
    ]
    browser.webRequest.onSendHeaders.addListener _on_send_headers, filter, [
      'requestHeaders'
    ]
    browser.webRequest.onHeadersReceived.addListener _on_headers_received, filter, [
      'responseHeaders'
    ]
    browser.webRequest.onResponseStarted.addListener _on_response_started, filter, [
      'responseHeaders'
    ]
    browser.webRequest.onCompleted.addListener _on_completed, filter, [
      'responseHeaders'
    ]
    browser.webRequest.onErrorOccurred.addListener _on_error, filter

  clean_up = ->
    browser.webRequest.onBeforeRequest.removeListener _on_before_request
    browser.webRequest.onBeforeRedirect.removeListener _on_before_redirect
    browser.webRequest.onBeforeSendHeaders.removeListener _on_before_send_headers
    browser.webRequest.onSendHeaders.removeListener _on_send_headers
    browser.webRequest.onHeadersReceived.removeListener _on_headers_received
    browser.webRequest.onResponseStarted.removeListener _on_response_started
    browser.webRequest.onCompleted.removeListener _on_completed
    browser.webRequest.onErrorOccurred.removeListener _on_error

  reset = ->
    # reset cache, and reset flag
    g.cache = {}
    g.cache_data = {}
    g.rc.after_reset = true
    # reset count
    g.rc.count = 0

    _report()  # update data

  get_cache = ->
    g.cache

  get_cache_data = ->
    g.cache_data

  # export API
  {
    init  # async
    set_rc_callback

    reset
    get_cache
    get_cache_data

    # clean up before remove
    clean_up
  }

module.exports = r_cache
