# m_action.coffee, pdso/src/lib/

{
  EVENT
} = require '../config'


tab_list = (payload) ->
  {
    type: EVENT.TAB_LIST
    payload  # tab_list data
  }

fetch_tab_list = ->
  {
    type: EVENT.FETCH_TAB_LIST
  }

set_tab_enable = (tab_id, enable) ->
  {
    type: EVENT.SET_TAB_ENABLE
    payload: {
      tab_id
      enable  # enable (true) / disable (false)
    }
  }

snapshot_one_tab = (payload) ->
  {
    type: EVENT.SNAPSHOT_ONE_TAB
    payload  # tab_id
  }


module.exports = {
  tab_list
  fetch_tab_list
  set_tab_enable
  snapshot_one_tab
}
