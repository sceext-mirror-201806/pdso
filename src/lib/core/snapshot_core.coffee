# snapshot_core.coffee, pdso/src/lib/core/
#
# the `one snapshot` steps:
#
# 1.1  (main bg) check and inject content scripts
# 1.2  (main bg) send event: C_SNAPSHOT
#
# 1.3  (contents) take a DOM snapshot, and clean it
# 1.4  (contents) send event: SNAPSHOT_DONE
#
# 2.1  (main bg) check r_cache for missing images
# 2.2  (main bg) send event: C_FETCH_IMGS
#
# 2.3  (contents) use `fetch()` to get one image from browser cache
# 2.4  (contents) send event: GOT_IMG
# 2.5  (main bg) store the image blob data in cache
#    note: 2.3 ~ 2.5 may repeat many times, one for an image
# 2.6  (contents) send event: FETCH_IMG_DONE
#
# 3.1  (main bg) start pack .. .
#

{
  CONTENT_EVENT
  CONTENTS
} = require '../config'
{
  send_to
  send_to_content
  m_send
} = require '../util'
m_ac = require '../m_action'

log = require './pack_log'
rename_res = require './rename_res'
pack_zip = require './pack_zip'


_execute_contents = (tab_id, file) ->
  await browser.tabs.executeScript tab_id, {
    file
    runAt: 'document_start'
  }

# inject content scripts
_inject_contents = (tab_id) ->
  log.d_inject_contents(tab_id)
  await _execute_contents tab_id, CONTENTS.lib
  await _execute_contents tab_id, CONTENTS.main


# first step of one snapshot: request content script to snapshot the DOM
_snapshot_first = (_g) ->
  log.info_snapshot_dom_and_clean(_g.tab_id)
  await send_to_content _g.tab_id, m_ac.c_snapshot()

# second step of one snappshot: check r_cache for missing images
_snapshot_second = (_g, payload) ->
  {
    html
    c_meta
  } = payload
  # TODO
  to = []

  # TODO
  log.d_fetch_imgs(_g.tab_id, to.length)
  await send_to_content _g.tab_id, m_ac.c_fetch_imgs(to)

_on_got_img = (_g, payload) ->
  {
    r_id
    base64: b64
  } = payload
  # TODO

# the last step of one snapshot: start pack
_snapshot_last = (_g) ->
  log.info_pack_start(_g.tab_id)

  # TODO
  log.ok_snapshot_end(_g.tab_id, 'TODO.zip')  # FIXME
  # enable the page
  m_send m_ac.snapshot_one_end(_g.tab_id)

_on_error = (tab_id, e) ->
  log.err_snapshot_end(tab_id, e)
  # enable the page
  m_send m_ac.snapshot_one_end(tab_id)

snapshot_core = (tab_id, tab_g, rc_g) ->
  # global data
  _g = {
    # save args
    tab_id
    tab_g
    rc_g

    injected: false  # true if content script injected
  }

  start = ->
    log.info_snapshot_start(tab_id)
    # check and inject content lib
    if ! _g.injected
      await _inject_contents tab_id
      _g.injected = true

    try
      await _snapshot_first _g
    catch e
      _on_error tab_id, e

  on_content_event = (m) ->
    switch m.type
      when CONTENT_EVENT.SNAPSHOT_DONE
        try
          await _snapshot_second _g, m.payload
        catch e
          _on_error tab_id, e
      when CONTENT_EVENT.GOT_IMG
        # TODO error process
        await _on_got_img _g, m.payload
      when CONTENT_EVENT.FETCH_IMG_DONE
        try
          await _snapshot_last _g
        catch e
          _on_error tab_id, e
      when CONTENT_EVENT.ERROR
        {
          err
          stack
        }
        e = {  # mock error object
          toString: ->
            "content script  #{err}"
          stack
        }
        _on_error tab_id, e
      else
        console.log "WARNING: unknow event from content script\n#{JSON.stringify m}"

  clean_up = ->
    # TODO

  # export API
  {
    start  # async
    on_content_event  # async

    clean_up
  }

module.exports = snapshot_core
