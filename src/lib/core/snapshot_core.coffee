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
  base64_decode

  saveAs
} = require '../util'
m_ac = require '../m_action'

log = require './pack_log'
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

_get_missing_imgs = (_g, c_meta) ->
  {
    cache
    cache_data
  } = _g.rc_g

  o = [
    #{
    #  r_id: ''
    #  url: ''
    #}
  ]
  # build full_url to r_id index
  index = {
    #'full_url': 'r_id'
  }
  for r_id of cache
    for i in cache[r_id].url
      # NOTE not check r_id conflict here
      index[i] = r_id
  # check each image
  for i in c_meta.res.img
    r_id = index[i.full_url]
    if ! r_id?
      continue  # just ignore missing images
    # check empty
    if cache_data[r_id].length < 1
      # add to list
      o.push {
        r_id
        url: i.full_url  # need full_url here
      }
  o

# second step of one snappshot: check r_cache for missing images
_snapshot_second = (_g, payload) ->
  {
    html
    c_meta
  } = payload
  # save data
  _g.html = html
  _g.c_meta = c_meta
  # fetch missing images
  to = _get_missing_imgs _g, c_meta
  log.d_fetch_imgs(_g.tab_id, to.length)
  await send_to_content _g.tab_id, m_ac.c_fetch_imgs(to)

_on_got_img = (_g, payload) ->
  {
    r_id
    base64
  } = payload
  data = base64_decode(base64)
  # check r_id already exist
  if _g.ic[r_id]?
    console.log "WARNING: snapshot_core._on_got_img: r_id [ #{r_id} ] already exist"
  _g.ic[r_id] = data

# the last step of one snapshot: start pack
_snapshot_last = (_g) ->
  log.info_pack_start(_g.tab_id)

  o = await pack_zip {
    tab_id: _g.tab_id
    tab_list: _g.tab_g.list[_g.tab_id]
    cache: _g.rc_g.cache
    c_meta: _g.c_meta

    html: _g.html
    cache_data: _g.rc_g.cache_data
    ic: _g.ic
  }
  log.ok_snapshot_end(_g.tab_id, o.filename)
  # download the zip file
  await saveAs o.blob, o.filename

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

    # image cache, for GOT_IMG
    ic: {
      #'r_id': data  # Buffer
    }

    # data used to pack
    html: null
    c_meta: null
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
        try
          await _on_got_img _g, m.payload
        catch e
          # ignore error
          console.log "ERROR: snapshot_core._on_got_img: #{e}  #{e.stack}"
      when CONTENT_EVENT.FETCH_IMG_DONE
        try
          await _snapshot_last _g
        catch e
          _on_error tab_id, e
      when CONTENT_EVENT.ERROR
        {
          err
          stack
        } = m.payload
        e = {  # mock error object
          toString: ->
            "content script  #{err}"
          stack
        }
        _on_error tab_id, e
      else
        console.log "WARNING: unknow event from content script\n#{JSON.stringify m}"

  clean_up = ->
    # nothing todo

  # export API
  {
    start  # async
    on_content_event  # async

    clean_up
  }

module.exports = snapshot_core
