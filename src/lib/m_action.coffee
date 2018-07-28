# m_action.coffee, pdso/src/lib/

{
  EVENT
  CONTENT_EVENT
} = require './config'


tab_list = (payload) ->
  {
    type: EVENT.TAB_LIST
    payload  # tab_list data
  }

fetch_tab_list = ->
  {
    type: EVENT.FETCH_TAB_LIST
  }

set_tab_enable = (tab_id, enable) ->
  {
    type: EVENT.SET_TAB_ENABLE
    payload: {
      tab_id: Number.parseInt tab_id  # ensure tab_id is int
      enable  # enable (true) / disable (false)
    }
  }

snapshot_one_tab = (payload) ->
  {
    type: EVENT.SNAPSHOT_ONE_TAB
    payload  # tab_id
  }

snapshot_one_end = (payload) ->
  {
    type: EVENT.SNAPSHOT_ONE_END
    payload  # tab_id
  }

bg_log = (text) ->
  {
    type: EVENT.BG_LOG
    payload: {
      time: new Date().toISOString()  # current time
      text
      # TODO add `type` ?
    }
  }

# send by content scripts
content = (payload) ->
  {
    type: EVENT.CONTENT
    payload
  }

# send to content script
c_snapshot = ->
  {
    type: EVENT.C_SNAPSHOT
  }

c_fetch_imgs = (payload) ->
  {
    type: EVENT.C_FETCH_IMGS
    payload
    # payload: [
    #   {
    #     r_id: ''
    #     url: ''  # the url to fetch
    #   }
    # ]
  }

# send from content script
ce_snapshot_done = (payload) ->
  {
    type: CONTENT_EVENT.SNAPSHOT_DONE
    payload
    # payload: {
    #   html: ''  # html string of the document
    #   c_meta: {}  # meta data by content script
    # }
  }

ce_got_img = (payload) ->
  {
    type: CONTENT_EVENT.GOT_IMG
    payload
    # payload: {
    #   r_id: ''
    #   base64: ''  # binary image data in base64 encoding
    # }
  }

ce_fetch_img_done = ->
  {
    type: CONTENT_EVENT.FETCH_IMG_DONE
  }

ce_error = (e) ->
  {
    type: CONTENT_EVENT.ERROR
    payload: {
      err: "#{e}"
      stack: "#{e.stack}"
    }
  }

module.exports = {
  tab_list
  fetch_tab_list
  set_tab_enable
  snapshot_one_tab
  snapshot_one_end
  bg_log

  content
  c_snapshot
  c_fetch_imgs
  ce_snapshot_done
  ce_got_img
  ce_fetch_img_done
  ce_error
}
