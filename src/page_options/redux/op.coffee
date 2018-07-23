# op.coffee, pdso/src/page_options/redux/

config = require '../../config'


# main init after page load
load_init = ->
  (dispatch, getState) ->
    # TODO load theme key ?

    console.log "DEBUG: page_options init done. "
    # TODO
    await return

toggle_theme = ->
  (dispatch, getState) ->
    # TODO save theme ?

    await return


module.exports = {
  load_init  # thunk
  toggle_theme  # thunk
}
