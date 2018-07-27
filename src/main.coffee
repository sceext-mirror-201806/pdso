# main.coffee, pdso/src/

{
  EVENT
  LCK_PDSO_TAB_LIST_ENABLE_ALL
} = require './lib/config'
{
  gM

  m_send
  m_send_content
  m_set_on
} = require './lib/util'
m_ac = require './lib/m_action'

tab_list = require './lib/core/tab_list'


# global data
_g = {
  tl: null  # tab_list instance
}


# on recv message
_on_recv = (m, sender, sendResponse) ->
  switch m.type
    when EVENT.FETCH_TAB_LIST
      await _g.tl.fetch()
    when EVENT.SET_TAB_ENABLE
      {
        tab_id
        enable
      } = m.payload
      await _g.tl.set_tab_enable tab_id, enable
    when EVENT.SNAPSHOT_ONE_TAB
      tab_id = m.payload
      await _g.tl.snapshot_one tab_id
    else  # unknow event
      console.log "DEBUG: (main) recv unknow [ #{m.type} ]  #{JSON.stringify m}"

_init_tab_list = ->
  _g.tl = tab_list()
  await _g.tl.init()

_load_config = ->
  o = await browser.storage.local.get LCK_PDSO_TAB_LIST_ENABLE_ALL
  enable_all = o[LCK_PDSO_TAB_LIST_ENABLE_ALL]
  if enable_all is true
    _g.tl.set_enable_all true
  else
    _g.tl.set_enable_all false

_init = ->
  # init parts of main background
  await _init_tab_list()

  await _load_config()
  await _g.tl.first_init_enable_all()
  # set auto load config
  browser.storage.onChanged.addListener _load_config

  # listen to messages
  m_set_on _on_recv

  # export for DEBUG only
  window._g = _g

  console.log "DEBUG: main init done."

_init()

console.log "DEBUG: end of main.js"
