# tab_list.coffee, pdso/src/lib/core/

{
  EVENT
} = require '../../config'
{
  m_send
} = require '../util'
m_ac = require '../m_action'

r_cache = require './r_cache'


tab_list = ->
  # global data (to send)
  g = {
    # enable tab
    enable: {
      #'TAB_ID': false
    }
    # the tab_list data
    list: [
      #'TAB_ID': {
      #  id: 1  # tab_id
      #
      #  title: ''  # page title
      #  url: ''  # page url
      #  # TODO favicon url ?
      #  # TODO page loading state ?
      #  # TODO r_cache resources count ?
      #  # TODO page snapshot status ?
      #}
    ]
    # enable all tabs
    enable_all: false
  }
  # r_cache for each enable page
  rc = {
    #'TAB_ID': null  # r_cache instance
  }
  # fetch tab_list data (update)
  fetch = ->
    m_send m_ac.tab_list(g)

  # TODO

  # event listeners
  # TODO

  _add_listeners = ->
    # TODO

  _init_fetch_list = ->
    # TODO

  init = ->
    _add_listeners()
    await _init_fetch_list()

    fetch()  # update data (first time)

  set_tab_enable = (tab_id, enable) ->
    g.enable[tab_id] = enable
    # TODO operate on r_cache ?
    fetch()  # update data

  set_enable_all = (enable) ->
    g.enable_all = enable
    fetch()  # update data

  # export API
  {
    init  # async
    fetch
    set_tab_enable
    set_enable_all
    # TODO snapshot_one_tab ?
  }

module.exports = tab_list
