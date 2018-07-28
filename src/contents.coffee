# contents.coffee, pdso/src/

{
  EVENT
} = require './lib/config'
{
  m_set_on
  send_to
} = require './lib/util'
m_ac = require './lib/m_action'

clean_dom = require './lib/core/clean_dom'


_send = (m) ->
  await send_to m_ac.content(m)

_snapshot = ->
  # TODO
  o = {  # TODO
    html: 'TODO'
    c_meta: {}
  }
  await _send m_ac.ce_snapshot_done(o)

_fetch_one_img = () ->
  # TODO

_fetch_imgs = (payload) ->
  # TODO
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
