# app.coffee, pdso/src/lib/page_options/
React = require 'react'
PropTypes = require 'prop-types'
cC = require 'create-react-class'

{
  CssBaseline
} = require '@material-ui/core'

{
  m_set_on
  m_remove_listener
} = require '../util'

Theme = require '../ui/theme'
MainContent = require './main_content'


App = cC {
  displayName: 'App'
  propTypes: {
    theme: PropTypes.string

    on_init: PropTypes.func.isRequired  # page load init
    on_recv: PropTypes.func.isRequired
  }

  componentDidMount: ->
    # listen messages first
    m_set_on @props.on_recv
    # and then emit init
    await @props.on_init()

  componentWillUnmount: ->
    m_remove_listener @props.on_recv

  render: ->
    (
      <Theme theme={ @props.theme }>
        <CssBaseline />
        <MainContent />
      </Theme>
    )
}

# for redux
{ connect } = require 'react-redux'

action = require './redux/action'
op = require './redux/op'

mapStateToProps = ($$state, props) ->
  {
    theme: $$state.get 'theme'
  }

mapDispatchToProps = (dispatch, props) ->
  o = Object.assign {}, props
  o.on_init = ->
    dispatch op.load_init()
  o.on_recv = (m, sender, sendResponse) ->
    await dispatch op.on_recv(m, sender, sendResponse)
  o

module.exports = connect(mapStateToProps, mapDispatchToProps)(App)
