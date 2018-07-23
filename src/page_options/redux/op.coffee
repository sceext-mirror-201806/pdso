# op.coffee, pdso/src/page_options/redux/

config = require '../../config'
action = require './action'


# main init after page load
load_init = ->
  (dispatch, getState) ->
    # TODO load theme key ?

    console.log "DEBUG: page_options init done. "
    # TODO
    await return

toggle_theme = ->
  (dispatch, getState) ->
    theme = getState().get 'theme'
    if theme is config.UI_THEME_DARK
      new_theme = config.UI_THEME_LIGHT
    else
      new_theme = config.UI_THEME_DARK
    # TODO save new theme to local storage

    # set new theme
    dispatch action.set_theme(new_theme)


module.exports = {
  load_init  # thunk
  toggle_theme  # thunk
}
