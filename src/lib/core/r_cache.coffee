# r_cache.coffee, pdso/src/lib/core/

snapshot_core = require './snapshot_core'


r_cache = (tab_id) ->
  # global data
  _g = {
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
      #  data_done: false  # stream_filter.onstop()
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
    # instance of snapshot_core
    s_core: null
  }
  # report rc to parent
  _report = ->
    _g.rc_callback?(tab_id, _g.rc)

  set_rc_callback = (cb) ->
    _g.rc_callback = cb
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
    if ! _g.cache[r_id]?
      # init info cache
      _g.cache[r_id] = {
        r_id
        error: false
        error_desc: null
        res_start: false
        done: false
        data_done: false

        url: [ url ]

        method
        type
        frame_id: frameId
      }
      # init data cache
      _g.cache_data[r_id] = []
      # update count
      _g.rc.count += 1

  # add url to the request if not exist
  _add_url = (r_id, url) ->
    # assert: _g.cache[r_id] != null
    if _g.cache[r_id].url.indexOf(url) is -1
      _g.cache[r_id].url.push url

  # save resources response data
  _init_stream_filter = (r_id) ->
    f = browser.webRequest.filterResponseData r_id

    f.onstart = (event) ->
      # check cache_data already exist
      if _g.cache_data[r_id]?
        if _g.cache_data[r_id].length > 0
          console.log "WARNING: r_cache: reset cache_data, tab_id = #{tab_id}, r_id = #{r_id}"
      # rest it
      _g.cache_data[r_id] = []

    f.ondata = (event) ->
      {
        data
      } = event

      f.write(data)
      # save in cache_data
      _g.cache_data[r_id].push data

    f.onstop = (event) ->
      f.disconnect()
      # mark res data recv done
      _g.cache[r_id].data_done = true

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
    if ! _g.sf_installed[r_id]
      _init_stream_filter r_id
      _g.sf_installed[r_id] = true

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
    # assert: _g.cache[r_id] != null
    _g.cache[r_id].res_start = true

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
    # assert: _g.cache[r_id] != null
    _g.cache[r_id].done = true

  _on_error = (details) ->
    {
      requestId: r_id
      tabId
      error
      #timeStamp
      fromCache
      ip
    } = details
    # assert: _g.cache[r_id] != null
    _g.cache[r_id].error = true
    _g.cache[r_id].error_desc = error

  # only listen events for this tab
  _filter = {
    urls: [
      '<all_urls>'
    ]
    tabId: tab_id
  }

  init = ->
    browser.webRequest.onBeforeRequest.addListener _on_before_request, _filter, [
      'blocking'  # block request for _init_stream_filter
      'requestBody'
    ]
    browser.webRequest.onBeforeRedirect.addListener _on_before_redirect, _filter, [
      'responseHeaders'
    ]
    browser.webRequest.onBeforeSendHeaders.addListener _on_before_send_headers, _filter, [
      'requestHeaders'
    ]
    browser.webRequest.onSendHeaders.addListener _on_send_headers, _filter, [
      'requestHeaders'
    ]
    browser.webRequest.onHeadersReceived.addListener _on_headers_received, _filter, [
      'responseHeaders'
    ]
    browser.webRequest.onResponseStarted.addListener _on_response_started, _filter, [
      'responseHeaders'
    ]
    browser.webRequest.onCompleted.addListener _on_completed, _filter, [
      'responseHeaders'
    ]
    browser.webRequest.onErrorOccurred.addListener _on_error, _filter

  clean_up = ->
    browser.webRequest.onBeforeRequest.removeListener _on_before_request
    browser.webRequest.onBeforeRedirect.removeListener _on_before_redirect
    browser.webRequest.onBeforeSendHeaders.removeListener _on_before_send_headers
    browser.webRequest.onSendHeaders.removeListener _on_send_headers
    browser.webRequest.onHeadersReceived.removeListener _on_headers_received
    browser.webRequest.onResponseStarted.removeListener _on_response_started
    browser.webRequest.onCompleted.removeListener _on_completed
    browser.webRequest.onErrorOccurred.removeListener _on_error
    # check and clean core
    if _g.s_core?
      _g.s_core.clean_up()

  reset = ->
    # reset cache, and reset flag
    _g.cache = {}
    _g.cache_data = {}
    _g.rc.after_reset = true
    # reset count
    _g.rc.count = 0
    # reset s_core
    if _g.s_core?
      _g.s_core.clean_up()
      _g.s_core = null

    _report()  # update data

  get_cache = ->
    _g.cache

  get_cache_data = ->
    _g.cache_data

  snapshot_one = (tab_g) ->
    # check and create core
    if ! _g.s_core?
      _g.s_core = snapshot_core tab_id, tab_g, _g
    await _g.s_core.start()

  on_content_event = (m) ->
    await _g.s_core.on_content_event m

  # export API
  {
    init  # async
    set_rc_callback

    reset
    get_cache
    get_cache_data

    # clean up before remove
    clean_up

    # for snapshot_core
    snapshot_one  # async
    on_content_event  # async

    # export for DEBUG
    _g
  }

module.exports = r_cache
