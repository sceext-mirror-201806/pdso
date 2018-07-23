# action.coffee, pdso/src/page_options/redux/

A_SET_THEME = 'a_set_theme'


set_theme = (payload) ->
  {
    type: A_SET_THEME
    payload
  }

module.exports = {
  A_SET_THEME

  set_theme
}
