# page_main.coffee, pdso/src/page_options/
React = require 'react'
PropTypes = require 'prop-types'
cC = require 'create-react-class'
{ compose } = require 'recompose'

{
  CssBaseline

  AppBar
  Toolbar
  Typography
  IconButton
  Tooltip
} = require '@material-ui/core'
{
  withStyles
} = require '@material-ui/core/styles'
{ default: LightbulbOutlineIcon } = require '@material-ui/icons/LightbulbOutline'
{ default: LightbulbFullIcon } = require '@material-ui/docs/svgIcons/LightbublFull'

{
  UI_THEME_LIGHT
  UI_THEME_DARK
} = require '../config'

Theme = require '../ui/theme'


PageMain = cC {
  displayName: 'PageMain'
  propTypes: {
    classes: PropTypes.object.isRequired
    theme: PropTypes.string

    on_toggle_theme: PropTypes.func.isRequired
    on_init: PropTypes.func.isRequired  # page load init
  }

  componentDidMount: ->
    @props.on_init()

  _render_bulb: ->
    if @props.theme is UI_THEME_DARK
      (
        <LightbulbFullIcon />
      )
    else
      (
        <LightbulbOutlineIcon />
      )

  _get_toggle_theme_tooltip: ->
    # TODO i18n
    if @props.theme is UI_THEME_DARK
      'Current is dark theme'
    else
      'Click to enable dark theme'

  _render_appbar: ->
    (
      <AppBar position="sticky">
        <Toolbar>
          <Typography variant="title" color="inherit">
            pdso (TODO i18n)
          </Typography>
          <div className={ @props.classes.grow } />

          <Tooltip title={ @_get_toggle_theme_tooltip() }>
            <IconButton color="inherit" onClick={ @props.on_toggle_theme }>
              { @_render_bulb() }
            </IconButton>
          </Tooltip>
        </Toolbar>
      </AppBar>
    )

  _render_contents: ->
    (
      <p>TODO contents part</p>
    )

  render: ->
    (
      <Theme theme={ @props.theme }>
        <CssBaseline />
        <div className={ @props.classes.root }>
          { @_render_appbar() }
          { @_render_contents() }
        </div>
      </Theme>
    )
}

styles = (theme) ->
  {
    grow: {
      flex: '1 1 auto'
    }
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

module.exports = compose(
  withStyles(styles, {
    name: 'PageMain'
  })
  connect(mapStateToProps, mapDispatchToProps)
)(PageMain)
