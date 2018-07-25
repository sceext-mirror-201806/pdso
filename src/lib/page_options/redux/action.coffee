# action.coffee, pdso/src/lib/page_options/redux/

A_SET_THEME = 'a_set_theme'
A_SET_PAGE = 'a_set_page'
A_SET_TAB_LIST_DATA = 'a_set_tab_list_data'


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

set_tab_list_data = (payload) ->
  {
    type: A_SET_TAB_LIST_DATA
    payload
  }

module.exports = {
  A_SET_THEME
  A_SET_PAGE
  A_SET_TAB_LIST_DATA

  set_theme
  set_page
  set_tab_list_data
}
