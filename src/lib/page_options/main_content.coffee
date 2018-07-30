# main_content.coffee, pdso/src/lib/page_options/
React = require 'react'
PropTypes = require 'prop-types'
cC = require 'create-react-class'
{ compose } = require 'recompose'

{
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
{ default: SwipeableViews } = require 'react-swipeable-views'
# icons
{ default: Icons_List } = require '@material-ui/icons/List'
{ default: Icons_Assessment } = require '@material-ui/icons/Assessment'
{ default: Icons_Info } = require '@material-ui/icons/Info'
{ default: IconM_Lightbulb } = require 'mdi-material-ui/Lightbulb'
{ default: IconM_LightbulbOutline } = require 'mdi-material-ui/LightbulbOutline'

{
  UI_THEME_LIGHT
  UI_THEME_DARK
} = require '../config'
{
  gM
} = require '../util'

TabList = require './tab_list'
TabLog = require './tab_log'
TabAbout = require './tab_about'


MainContent = cC {
  displayName: 'MainContent'
  propTypes: {
    classes: PropTypes.object.isRequired
    page_value: PropTypes.number.isRequired
    theme: PropTypes.string

    on_toggle_theme: PropTypes.func.isRequired
    on_change_page: PropTypes.func.isRequired
  }

  _render_bulb: ->
    if @props.theme is UI_THEME_DARK
      (
        <IconM_Lightbulb />
      )
    else
      (
        <IconM_LightbulbOutline />
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
      minWidth: '108px'
    }

    (
      <Tab
        style={ tab_style }
        classes={{
          wrapper: @props.classes.tab_item_wrapper
          root: @props.classes.tab_item
          selected: @props.classes.selected
        }}
        label={ label }
        icon={ icon }
      />
    )

  _render_tabs: ->
    (
      <React.Fragment>
        <Tabs
          value={ @props.page_value }
          onChange={ @_on_page_change }
          indicatorColor="primary"
          textColor="primary"
          centered
        >
          { @_render_one_tab gM('po_tab_list'), (<Icons_List />) }
          { @_render_one_tab gM('po_tab_log'), (<Icons_Assessment />) }
          { @_render_one_tab gM('po_tab_about'), (<Icons_Info />) }
        </Tabs>
        <SwipeableViews
          axis="x"
          index={ @props.page_value }
          onChangeIndex={ @_on_page_index_change }
        >
          <TabList />
          <TabLog />
          <TabAbout />
        </SwipeableViews>
      </React.Fragment>
    )

  render: ->
    (
      <div className={ @props.classes.root }>
        { @_render_appbar() }
        { @_render_tabs() }
      </div>
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

    tab_item: {
      '&$selected': {
        color: theme.tb.color_tab
      }
    }
    selected: {}
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
  o.on_toggle_theme = ->
    dispatch op.toggle_theme()
  o.on_change_page = (value) ->
    dispatch action.set_page(value)
  o

module.exports = compose(
  withStyles(styles, {
    name: 'MainContent'
  })
  connect(mapStateToProps, mapDispatchToProps)
)(MainContent)
