# main.coffee, pdso/src/

{
  EVENT
  LCK_PDSO_TAB_LIST_ENABLE_ALL
} = require './config'
{
  gM

  m_send
  m_send_content
  m_set_on
} = require './lib/util'
m_ac = require './lib/m_action'

tab_list = require './lib/core/tab_list'


# global data
g = {
  tl: null  # tab_list instance
}


# on recv message
_on_recv = (m, sender, sendResponse) ->
  switch m.type
    when EVENT.FETCH_TAB_LIST
      await g.tl.fetch()
    when EVENT.SET_TAB_ENABLE
      {
        tab_id
        enable
      } = m.payload
      await g.tl.set_tab_enable tab_id, enable
    when EVENT.SNAPSHOT_ONE_TAB
      # TODO
      console.log "FIXME: snapshot_one_tab not implemented"
    else  # unknow event
      console.log "DEBUG: (main) recv unknow [ #{m.type} ]  #{JSON.stringify m}"

_init_tab_list = ->
  g.tl = tab_list()
  await g.tl.init()

_load_config = ->
  o = await browser.storage.local.get LCK_PDSO_TAB_LIST_ENABLE_ALL
  enable_all = o[LCK_PDSO_TAB_LIST_ENABLE_ALL]
  if enable_all is true
    g.tl.set_enable_all true
  else
    g.tl.set_enable_all false

_init = ->
  # init parts of main background
  await _init_tab_list()

  await _load_config()
  # set auto load config
  browser.storage.onChanged.addListener _load_config

  # listen to messages
  m_set_on _on_recv

  console.log "DEBUG: main init done."

_init()

console.log "DEBUG: end of main.js"
