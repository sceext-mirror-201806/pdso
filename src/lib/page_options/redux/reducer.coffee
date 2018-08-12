# reducer.coffee, pdso/src/lib/page_options/redux/

Immutable = require 'immutable'

state = require './state'
ac = require './action'

_check_init = ($$o) ->
  if ! $$o?
    $$o = Immutable.fromJS state
  $$o

reducer = ($$state, action) ->
  $$o = _check_init $$state
  switch action.type
    when ac.A_SET_THEME
      $$o = $$o.set 'theme', action.payload
    when ac.A_SET_PAGE
      $$o = $$o.set 'page_value', action.payload
    when ac.A_SET_TAB_LIST_DATA
      $$o = $$o.set 'g', Immutable.fromJS(action.payload)
    when ac.A_ADD_LOG
      $$o = $$o.update 'log', ($$) ->
        $$.push Immutable.fromJS(action.payload)
    when ac.A_SET_DISABLE_TAB
      {
        tab_id
        disable
      } = action.payload
      $$o = $$o.setIn ['disable_tab', tab_id], disable
    when ac.A_SET_CONFIG
      $$o = $$o.update 'config', ($$) ->
        $$.merge Immutable.fromJS(action.payload)
    when ac.A_SET_JSZIP_UPDATE
      $$o = $$o.set 'jszip_update', Immutable.fromJS(action.payload)

  $$o

module.exports = reducer
