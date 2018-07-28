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
# TODO error report ?
#

{
  CONTENT_EVENT
  CONTENTS
} = require '../config'
{
  send_to
  send_to_content
} = require '../util'
m_ac = require '../m_action'

log = require './pack_log'
rename_res = require './rename_res'
pack_zip = require './pack_zip'

# TODO strict error check and process ?


_execute_contents = (tab_id, file) ->
  await browser.tabs.executeScript tab_id, {
    file
    runAt: 'document_start'
  }

# inject content scripts
_inject_contents = (tab_id) ->
  log.info_inject_contents(tab_id)
  await _execute_contents tab_id, CONTENTS.lib
  await _execute_contents tab_id, CONTENTS.main


# first step of one snapshot: request content script to snapshot the DOM
_snapshot_first = (_g) ->
  # TODO

# second step of one snappshot: check r_cache for missing images
_snpashot_second = (_g) ->
  # TODO

# the last step of one snapshot: start pack
_snapshot_last = (_g) ->
  # TODO


# TODO more error process ?
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
    await _snapshot_first _g

  on_content_event = (m) ->
    # TODO

  clean_up = ->
    # TODO

  # export API
  {
    start  # async
    on_content_event  # async

    clean_up
  }

module.exports = snapshot_core