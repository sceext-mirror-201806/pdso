# contents.coffee, pdso/src/

{
  EVENT
} = require './lib/config'
{
  m_set_on
  send_to
  base64_encode
} = require './lib/util'
m_ac = require './lib/m_action'

clean_dom = require './lib/core/clean_dom'


_send = (m) ->
  await send_to m_ac.content(m)

_snapshot = ->
  # snapshot the DOM
  root = document.cloneNode(true)
  # clean it
  o = clean_dom root

  await _send m_ac.ce_snapshot_done(o)

_fetch_one_img = (r_id, url) ->
  console.log "DEBUG: contents._fetch_one_img: r_id = #{r_id}, url = #{url}"
  try
    # use `fetch()` API
    r = await fetch(url)
    # TODO more checks on response ?
    arraybuffer = await r.arrayBuffer()
    base64 = base64_encode arraybuffer
    await _send m_ac.ce_got_img({
      r_id
      base64
    })
  catch e
    # ignore error here
    console.log "ERROR: contents._fetch_one_img: #{e}  #{e.stack}"

_fetch_imgs = (payload) ->
  for i in payload
    await _fetch_one_img i.r_id, i.url
  await _send m_ac.ce_fetch_img_done()

# report error
_on_error = (e) ->
  _send m_ac.ce_error(e)

# on recv message
_on_recv = (m, sender, sendResponse) ->
  switch m.type
    when EVENT.C_SNAPSHOT
      try
        await _snapshot()
      catch e
        _on_error e
    when EVENT.C_FETCH_IMGS
      try
        await _fetch_imgs(m.payload)
      catch e
        _on_error e
    else
      console.log "DEBUG: (contents) recv unknow [ #{m.type} ]  #{JSON.stringify m}"

_init = ->
  # listen to messages
  m_set_on _on_recv

  console.log "DEBUG: contents init done."

_init()

console.log "DEBUG: end of contents.js"
