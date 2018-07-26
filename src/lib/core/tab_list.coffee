# tab_list.coffee, pdso/src/lib/core/

{
  EVENT
} = require '../config'
{
  m_send
} = require '../util'
m_ac = require '../m_action'

r_cache = require './r_cache'


tab_list = ->
  # global data (to send)
  _g = {
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
      #  # loading status from browser.webNavigation API, possible values:
      #  # + '': no status (initial status)
      #  # + 'before': onCreatedNavigationTarget
      #  # + 'committed': onCommitted
      #  # + 'dom_loaded': onDOMContentLoaded
      #  # + 'completed': onCompleted
      #  # + 'error': onErrorOccurred
      #  navigation_status: ''
      #
      #  rc: {}  # (or `null`) r_cache report data
      #
      #  # TODO page snapshot status ?
      #}
    }
    # enable all tabs
    enable_all: false
  }
  # r_cache for each enable page
  _rc = {
    #'TAB_ID': null  # r_cache instance
  }
  # fetch tab_list data (update)
  fetch = ->
    m_send m_ac.tab_list(_g)

  # update _g.list from browser.tabs.Tab
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
    if ! _g.list[tab_id]?
      one.rc = null  # no rc now
      one.navigation_status = ''  # no status
      _g.list[tab_id] = one
    else  # already exist, just update info
      old = _g.list[tab_id]
      _g.list[tab_id] = Object.assign {}, old, one
    # return tab_id
    tab_id

  # rc operate
  _on_rc_report = (tab_id, rc) ->
    _g.list[tab_id].rc = rc
    fetch()  # update data

  _rc_create = (tab_id) ->
    # check rc already exists (for debug)
    if _rc[tab_id]?
      console.log "WARNING: r_cache for tab [ #{tab_id} ] already exist !  ignore rc create"
      return
    # create rc and init
    c = r_cache(tab_id)
    _rc[tab_id] = c
    c.set_rc_callback _on_rc_report
    await c.init()

  _rc_reset = (tab_id) ->
    # if rc not exist, will just throw
    _rc[tab_id].reset()

  _rc_remove = (tab_id) ->
    # clean first
    _rc[tab_id].clean_up()
    # remove rc
    _rc[tab_id] = null
    # remove rc data
    _g.list[tab_id].rc = null

  # event listeners
  _on_tab_create = (tab) ->
    tab_id = _update_tab_info tab
    # check enable_all
    if _g.enable_all and tab_id?
      await _rc_create tab_id
      _g.enable[tab_id] = true
    fetch()  # update data

  _on_tab_remove = (tab_id) ->
    # remove rc first, if exist
    if _rc[tab_id]?
      _rc_remove tab_id
    # delete tab info
    _g.list[tab_id] = null
    fetch()  # update data

  _on_tab_update = (tab_id, changeInfo, tab) ->
    _update_tab_info tab
    fetch()  # update data

  # webNavigation event listeners
  _on_nav_common = (details) ->
    {
      tabId: tab_id
      frameId: frame_id
    } = details
    # check tab_id
    if (! tab_id?) or (tab_id is browser.tabs.TAB_ID_NONE)
      return  # bad tab_id, ignore this
    # check frame_id
    if frame_id != 0
      return  # ignore not top frame
    # return tab_id
    tab_id

  _on_nav_before = (details) ->
    tab_id = _on_nav_common details
    if ! tab_id?
      return
    # update navigation_status
    _g.list[tab_id].navigation_status = 'before'
    # check tab enabled
    if _g.enable[tab_id]
      # TODO support no reset on a tab ?
      # reset rc here
      _rc_reset tab_id
    else
      fetch()  # update data

  # just update navigation_status, nothing else
  _on_nav_update_status = (details, status) ->
    tab_id = _on_nav_common details
    if ! tab_id?
      return
    # update navigation_status
    _g.list[tab_id].navigation_status = status
    fetch()  # update data

  _on_nav_committed = (details) ->
    _on_nav_update_status details, 'committed'

  _on_nav_dom_loaded = (details) ->
    _on_nav_update_status details, 'dom_loaded'

  _on_nav_completed = (details) ->
    _on_nav_update_status details, 'completed'

  _on_nav_error = (details) ->
    tab_id = _on_nav_common details
    if ! tab_id?
      return
    # log error
    console.log "DEBUG: tab_list._on_nav_error: tab [ #{tab_id} ]"
    # update navigation_status
    _g.list[tab_id].navigation_status = 'error'
    fetch()  # update data

  _add_listeners = ->
    browser.tabs.onCreated.addListener _on_tab_create
    browser.tabs.onRemoved.addListener _on_tab_remove
    browser.tabs.onUpdated.addListener _on_tab_update
    browser.webNavigation.onBeforeNavigate.addListener _on_nav_before
    browser.webNavigation.onCommitted.addListener _on_nav_committed
    browser.webNavigation.onDOMContentLoaded.addListener _on_nav_dom_loaded
    browser.webNavigation.onCompleted.addListener _on_nav_completed
    browser.webNavigation.onErrorOccurred.addListener _on_nav_error

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
    if enable
      # check already enabled
      if _g.enable[tab_id]
        console.log "WARNING: tab [ #{tab_id} ] already enabled !  ignore re-enable"
        return
      await _rc_create tab_id
      _g.enable[tab_id] = true
    else
      # check already disabled
      if ! _g.enable[tab_id]
        console.log "WARNING: tab [ #{tab_id} ] already disabled !  ignore re-disable"
        return
      _rc_remove tab_id
      _g.enable[tab_id] = false
    fetch()  # update data

  set_enable_all = (enable) ->
    _g.enable_all = enable
    fetch()  # update data

  first_init_enable_all = ->
    if _g.enable_all
      for i of _g.list
        await _rc_create i
        _g.enable[i] = true
      fetch()  # update data

  # export API
  {
    init  # async
    fetch
    set_tab_enable
    set_enable_all
    first_init_enable_all
    # TODO snapshot_one_tab ?

    # export for DEBUG
    _g
    _rc
  }

module.exports = tab_list
