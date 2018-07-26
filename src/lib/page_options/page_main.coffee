# page_main.coffee, pdso/src/lib/page_options/
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

  Tabs
  Tab
} = require '@material-ui/core'
{
  withStyles
} = require '@material-ui/core/styles'
Icons = require '@material-ui/icons'
IconM = require 'mdi-material-ui'
{ default: SwipeableViews } = require 'react-swipeable-views'

{
  UI_THEME_LIGHT
  UI_THEME_DARK
} = require '../config'
{
  gM

  m_set_on
  m_remove_listener
} = require '../util'

Theme = require '../ui/theme'
PageTabList = require './page_tab_list'
PageLog = require './page_log'
PageAbout = require './page_about'


PageMain = cC {
  displayName: 'PageMain'
  propTypes: {
    classes: PropTypes.object.isRequired
    page_value: PropTypes.number.isRequired
    theme: PropTypes.string

    on_toggle_theme: PropTypes.func.isRequired
    on_change_page: PropTypes.func.isRequired

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

  _render_bulb: ->
    if @props.theme is UI_THEME_DARK
      (
        <IconM.Lightbulb />
      )
    else
      (
        <IconM.LightbulbOutline />
      )

  _get_toggle_theme_tooltip: ->
    if @props.theme is UI_THEME_DARK
      gM 'po_theme_is_dark'
    else
      gM 'po_enable_dark_theme'

  _render_appbar: ->
    (
      <AppBar position="sticky">
        <Toolbar>
          <Typography variant="title" color="inherit">
            { gM 'po_title' }
          </Typography>
          <div className={ @props.classes.grow } />

          <Tooltip
            title={ @_get_toggle_theme_tooltip() }
            enterDelay={ 1000 }
            disableFocusListener
          >
            <IconButton color="inherit" onClick={ @props.on_toggle_theme }>
              { @_render_bulb() }
            </IconButton>
          </Tooltip>
        </Toolbar>
      </AppBar>
    )

  _on_page_change: (event, value) ->
    @props.on_change_page value

  _on_page_index_change: (index) ->
    @props.on_change_page index

  _render_one_tab: (label, icon) ->
    tab_style = {
      minHeight: '54px'
      minWidth: '144px'
    }

    (
      <Tab
        style={ tab_style }
        classes={{
          wrapper: @props.classes.tab_item_wrapper
        }}
        label={ label }
        icon={ icon }
      />
    )

  _render_contents: ->
    (
      <React.Fragment>
        <Tabs
          value={ @props.page_value }
          onChange={ @_on_page_change }
          indicatorColor="primary"
          textColor="primary"
          centered
        >
          { @_render_one_tab gM('po_tab_list'), (<Icons.List />) }
          { @_render_one_tab gM('po_tab_log'), (<Icons.Assessment />) }
          { @_render_one_tab gM('po_tab_about'), (<Icons.Info />) }
        </Tabs>
        <SwipeableViews
          axis="x"
          index={ @props.page_value }
          onChangeIndex={ @_on_page_index_change }
        >
          <PageTabList />
          <PageLog />
          <PageAbout />
        </SwipeableViews>
      </React.Fragment>
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

    tab_item_wrapper: {
      flexDirection: 'row'
    }
  }

# for redux
{ connect } = require 'react-redux'

action = require './redux/action'
op = require './redux/op'

mapStateToProps = ($$state, props) ->
  {
    theme: $$state.get 'theme'
    page_value: $$state.get 'page_value'
  }

mapDispatchToProps = (dispatch, props) ->
  o = Object.assign {}, props
  o.on_init = ->
    dispatch op.load_init()
  o.on_recv = (m, sender, sendResponse) ->
    await dispatch op.on_recv(m, sender, sendResponse)

  o.on_toggle_theme = ->
    dispatch op.toggle_theme()
  o.on_change_page = (value) ->
    dispatch action.set_page(value)
  o

module.exports = compose(
  withStyles(styles, {
    name: 'PageMain'
  })
  connect(mapStateToProps, mapDispatchToProps)
)(PageMain)
