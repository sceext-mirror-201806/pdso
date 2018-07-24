# op.coffee, pdso/src/page_options/redux/

config = require '../../config'
{
  gM
  m_send
} = require '../../lib/util'
m_ac = require '../../lib/m_action'

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


# on recv messages (options page)
on_recv = (m, sender, sendResponse) ->
  (dispatch, getState) ->
    {
      EVENT
    } = config
    switch m.type
      when EVENT.TAB_LIST
        dispatch action.set_tab_list_data(m.payload)
      else
        console.log "DEBUG: (options) recv unknow [ #{m.type} ]  #{JSON.stringify m}"

set_tab_enable = (tab_id, enable) ->
  (dispatch, getState) ->
    await m_send m_ac.set_tab_enable(tab_id, enable)

set_enable_all = (enable) ->
  (dispatch, getState) ->
    {
      LCK_PDSO_TAB_LIST_ENABLE_ALL
    } = config
    o = {}
    o[LCK_PDSO_TAB_LIST_ENABLE_ALL] = enable
    await browser.storage.local.set o

# TODO snapshot_one_tab

module.exports = {
  load_init  # thunk
  toggle_theme  # thunk

  on_recv  # thunk
  set_tab_enable  # thunk
  set_enable_all  # thunk
}
