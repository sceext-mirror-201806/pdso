# page_main.coffee, pdso/src/page_options/
React = require 'react'
PropTypes = require 'prop-types'
cC = require 'create-react-class'

{
  CssBaseline
} = require '@material-ui/core'

Theme = require '../ui/theme'


PageMain = cC {
  displayName: 'PageMain'
  propTypes: {
    theme: PropTypes.string

    on_toggle_theme: PropTypes.func.isRequired
    on_init: PropTypes.func.isRequired  # page load init
  }

  componentDidMount: ->
    @props.on_init()

  render: ->
    # TODO

    (
      <React.Fragment>
        <CssBaseline />
        <Theme theme={ @props.theme }>
          # TODO
        </Theme>
      </React.Fragment>
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
  o.on_toggle_theme = ->
    dispatch op.toggle_theme()
  o

module.exports = connect(mapStateToProps, mapDispatchToProps)(PageMain)
