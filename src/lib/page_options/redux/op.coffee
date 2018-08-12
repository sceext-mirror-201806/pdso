# op.coffee, pdso/src/lib/page_options/redux/

config = require '../../config'
{
  gM
  m_send
  check_jszip_level
} = require '../../util'
m_ac = require '../../m_action'

action = require './action'


# main init after page load
load_init = ->
  (dispatch, getState) ->
    # load configs
    {
      UI_THEME_LIGHT
      UI_THEME_DARK
      LCK_UI_THEME
    } = config
    # ui.theme
    o = await browser.storage.local.get LCK_UI_THEME
    if o[LCK_UI_THEME] is UI_THEME_DARK
      theme = UI_THEME_DARK
    else
      theme = UI_THEME_LIGHT
    dispatch action.set_theme(theme)
    # pdso.jszip_level
    pdso_jszip_level = await check_jszip_level()
    dispatch action.set_config({
      pdso_jszip_level
    })
    # fetch tab_list
    await m_send m_ac.fetch_tab_list()

    console.log "DEBUG: page_options init done. "

toggle_theme = ->
  (dispatch, getState) ->
    theme = getState().get 'theme'
    if theme is config.UI_THEME_DARK
      new_theme = config.UI_THEME_LIGHT
    else
      new_theme = config.UI_THEME_DARK
    # save new theme to local storage
    o = {}
    o[config.LCK_UI_THEME] = new_theme
    await browser.storage.local.set o

    # set new theme
    dispatch action.set_theme(new_theme)

set_jszip_level = (level) ->
  (dispatch, getState) ->
    o = {}
    o[config.LCK_PDSO_JSZIP_LEVEL] = level
    await browser.storage.local.set o

    dispatch action.set_config({
      pdso_jszip_level: level
    })


# on recv messages (options page)
on_recv = (m, sender, sendResponse) ->
  (dispatch, getState) ->
    {
      EVENT
    } = config
    switch m.type
      when EVENT.TAB_LIST
        dispatch action.set_tab_list_data(m.payload)
      when EVENT.BG_LOG
        dispatch action.add_log(m.payload)
      when EVENT.SNAPSHOT_ONE_END
        tab_id = m.payload
        # enable the tab
        dispatch action.set_disable_tab(tab_id, false)
      when EVENT.JSZIP_UPDATE
        dispatch action.set_jszip_update(m.payload)
      else
        console.log "DEBUG: (options) recv unknow [ #{m.type} ]  #{JSON.stringify m}"

set_tab_enable = (tab_id, enable) ->
  (dispatch, getState) ->
    await m_send m_ac.set_tab_enable(tab_id, enable)

add_favicon_blacklist = (tab_id, u) ->
  (dispatch, getState) ->
    await m_send m_ac.add_favicon_blacklist(tab_id, u)

set_enable_all = (enable) ->
  (dispatch, getState) ->
    {
      LCK_PDSO_TAB_LIST_ENABLE_ALL
    } = config
    o = {}
    o[LCK_PDSO_TAB_LIST_ENABLE_ALL] = enable
    await browser.storage.local.set o

# snapshot one tab
snapshot_one = (tab_id) ->
  (dispatch, getState) ->
    # disable the tab first
    dispatch action.set_disable_tab(tab_id, true)
    # goto log tab
    dispatch action.set_page(1)
    # start one snapshot
    await m_send m_ac.snapshot_one_tab(tab_id)

module.exports = {
  load_init  # thunk
  toggle_theme  # thunk
  set_jszip_level  # thunk

  on_recv  # thunk
  set_tab_enable  # thunk
  add_favicon_blacklist  # thunk
  set_enable_all  # thunk
  snapshot_one  # thunk
}
