# action.coffee, pdso/src/lib/page_options/redux/

A_SET_THEME = 'a_set_theme'
A_SET_PAGE = 'a_set_page'
A_SET_TAB_LIST_DATA = 'a_set_tab_list_data'
A_ADD_LOG = 'a_add_log'
A_SET_DISABLE_TAB = 'a_set_disable_tab'


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

add_log = (payload) ->
  {
    type: A_ADD_LOG
    payload
  }

set_disable_tab = (tab_id, disable) ->
  {
    type: A_SET_DISABLE_TAB
    payload: {
      tab_id: Number.parseInt tab_id  # ensure tab_id is int
      disable
    }
  }

module.exports = {
  A_SET_THEME
  A_SET_PAGE
  A_SET_TAB_LIST_DATA
  A_ADD_LOG
  A_SET_DISABLE_TAB

  set_theme
  set_page
  set_tab_list_data
  add_log
  set_disable_tab
}
