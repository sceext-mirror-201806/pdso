# reducer.coffee, pdso/src/page_options/redux/

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

  $$o

module.exports = reducer
