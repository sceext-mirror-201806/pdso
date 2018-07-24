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
    list: {
      #'TAB_ID': {
      #  id: 1  # tab_id
      #  incognito: false  # true if tab is incognito mode
      #
      #  title: ''  # page title
      #  url: ''  # page url
      #
      #  favicon_url: ''  # WARNING not support on Firefox Android
      #  loading_status: ''  # [ 'loading', 'complete' ]
      #
      #  # TODO r_cache resources count ?
      #  # TODO page snapshot status ?
      #}
    }
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

  # update g.list from browser.tabs.Tab
  _update_tab_info = (tab) ->
    # check tab_id first
    tab_id = tab.id
    if (! tab_id?) or (tab_id is browser.tabs.TAB_ID_NONE)
      return  # ignore this tab
    # get tab info
    one = {
      id: tab.id
      incognito: tab.incognito

      title: tab.title
      url: tab.url

      favicon_url: tab.favIconUrl
      loading_status: tab.status
    }
    # check tab data exist
    if ! g.list[tab_id]?
      g.list[tab_id] = one
    else  # already exist, just update info
      old = g.list[tab_id]
      g.list[tab_id] = Object.assign {}, old, one
    # return tab_id
    tab_id


  # event listeners

  _on_tab_create = (tab) ->
    tab_id = _update_tab_info tab
    # check enable_all
    if g.enable_all and tab_id?
      g.enable[tab_id] = true
      # TODO create rc ?
    fetch()  # update data

  _on_tab_remove = (tab_id) ->
    # delete tab info
    g.list[tab_id] = null
    # TODO remove rc ?
    fetch()  # update data

  _on_tab_update = (tab_id, changeInfo, tab) ->
    _update_tab_info tab
    fetch()  # update data

  _add_listeners = ->
    browser.tabs.onCreated.addListener _on_tab_create
    browser.tabs.onRemoved.addListener _on_tab_remove
    browser.tabs.onUpdated.addListener _on_tab_update
    # TODO event listeners about webNavigation ?

  # init fetch all tabs
  _init_fetch_list = ->
    r = await browser.tabs.query({})
    for i in r
      _update_tab_info i

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

  first_init_enable_all = ->
    if g.enable_all
      for i of g.list
        g.enable[i] = true
        # TODO create rc ?
      fetch()  # update data

  # export API
  {
    init  # async
    fetch
    set_tab_enable
    set_enable_all
    first_init_enable_all
    # TODO snapshot_one_tab ?
  }

module.exports = tab_list
