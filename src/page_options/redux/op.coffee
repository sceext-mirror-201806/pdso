# op.coffee, pdso/src/page_options/redux/

config = require '../../config'
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


module.exports = {
  load_init  # thunk
  toggle_theme  # thunk
}
