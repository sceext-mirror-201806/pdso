# action.coffee, pdso/src/page_options/redux/

A_SET_THEME = 'a_set_theme'
A_SET_PAGE = 'a_set_page'


set_theme = (payload) ->
  {
    type: A_SET_THEME
    payload
  }

set_page = (payload) ->
  {
    type: A_SET_PAGE
    payload
  }

module.exports = {
  A_SET_THEME
  A_SET_PAGE

  set_theme
  set_page
}
