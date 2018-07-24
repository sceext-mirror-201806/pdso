# page_tab_list.coffee, pdso/src/page_options/
React = require 'react'
PropTypes = require 'prop-types'
cC = require 'create-react-class'
{ compose } = require 'recompose'

{ withStyles } = require '@material-ui/core/styles'
{
  Typography
  Paper
  Switch
  List
  ListItem
  ListItemText
  ListItemSecondaryAction
  Avatar
  Chip
  Tooltip
  CircularProgress
} = require '@material-ui/core'
Icons = require '@material-ui/icons'

{
  gM
} = require '../lib/util'


OneItem = cC {
  displayName: 'PageTabList_OneItem'
  propTypes: {
    classes: PropTypes.object.isRequired
    g: PropTypes.object.isRequired
    tab_id: PropTypes.string.isRequired

    on_set_tab_enable: PropTypes.func.isRequired
  }

  _on_toggle: ->
    @props.on_set_tab_enable(@props.tab_id, ! @_get_enable())

  _get_one: ->
    @props.g.list[@props.tab_id]

  _get_enable: ->
    if @props.g.enable[@props.tab_id]
      true
    else
      false

  _get_switch_tooltip: ->
    # TODO i18n
    if @_get_enable()
      'This tab is enabled'
    else
      'Click to enable this tab (current disabled)'

  _gen_title: ->
    one = @_get_one()
    # TODO i18n

    if one.incognito
      "[incognito] #{one.title}"
    else
      one.title

  _render_second: ->
    one = @_get_one()

    (
      <React.Fragment>
        { one.url }
        <Chip
          label={ one.id }
          classes={{
            root: @props.classes.chip
            label: @props.classes.chip_label
          }}
        />
      </React.Fragment>
    )

  render: ->
    (
      <ListItem>
        <Avatar>
          <Icons.Folder />
        </Avatar>
        <ListItemText primary={ @_gen_title() } secondary={ @_render_second() } />
        <ListItemSecondaryAction>
          <Tooltip
            title={ @_get_switch_tooltip() }
            enterDelay={ 1000 }
            disableFocusListener
            placement="left"
          >
            <Switch checked={ @_get_enable() } onChange={ @_on_toggle } color="primary" />
          </Tooltip>
        </ListItemSecondaryAction>
      </ListItem>
    )
}

PageTabList = cC {
  displayName: 'PageTabList'
  propTypes: {
    classes: PropTypes.object.isRequired

    # tab_list data to render
    g: PropTypes.object.isRequired

    on_set_tab_enable: PropTypes.func.isRequired
    on_set_enable_all: PropTypes.func.isRequired
    # TODO snapshot of one ?
  }

  _on_toggle_enable_all: ->
    @props.on_set_enable_all(! @props.g.enable_all)

  _gen_list: ->
    # sort list by tab_id
    o = []
    for i of @props.g.list
      # check tab exist
      if @props.g.list[i]?
        o.push i
    o.sort (a, b) ->
      a - b
    o

  _render_placeholder: ->
    (
      <div className={ @props.classes.placeholder }>
        <CircularProgress />
      </div>
    )

  _render_list: ->
    to = @_gen_list()
    # check list length
    if to.length < 1
      body = @_render_placeholder()
    else
      o = []
      for i in to
        o.push (
          <OneItem
            key={ i }
            classes={ @props.classes }
            g={ @props.g }
            tab_id={ i }
            on_set_tab_enable={ @props.on_set_tab_enable }
          />
        )
      body = (
        <List>{ o }</List>
      )

    (
      <Paper className={ @props.classes.paper_list }>
        { body }
      </Paper>
    )

  _render_enable_all: ->
    # TODO i18n
    (
      <Paper className={ @props.classes.paper }>
        <div className={ @props.classes.enable_all_title }>
          <Typography variant="headline" component="h3">
            Enable for all pages by default
          </Typography>
          <Switch checked={ @props.g.enable_all } onChange={ @_on_toggle_enable_all } color="primary" />
        </div>
        <Typography>
          TODO
        </Typography>
      </Paper>
    )

  render: ->
    (
      <div className={ @props.classes.root }>
        { @_render_list() }
        { @_render_enable_all() }
      </div>
    )
}

styles = (theme) ->
  {
    paper: {
      padding: theme.spacing.unit * 2
      paddingRight: '4px'  # FIXME
      margin: theme.spacing.unit
      marginTop: theme.spacing.unit * 2
    }
    paper_list: {  # no padding
      margin: theme.spacing.unit
      marginTop: theme.spacing.unit * 2
    }
    enable_all_title: {
      display: 'flex'

      '& h3': {
        flex: 1
      }
    }
    chip: {
      marginLeft: theme.spacing.unit
      height: 'auto'
      cursor: 'auto'
      color: 'inherit'
    }
    chip_label: {
      display: 'initial'
      userSelect: 'auto'
      textAlign: 'center'
    }
    placeholder: {
      padding: theme.spacing.unit * 2
      display: 'flex'
      justifyContent: 'center'
    }
  }

# for redux
{ connect } = require 'react-redux'

action = require './redux/action'
op = require './redux/op'

mapStateToProps = ($$state, props) ->
  {
    g: $$state.get('g').toJS()
  }

mapDispatchToProps = (dispatch, props) ->
  o = Object.assign {}, props

  o.on_set_tab_enable = (tab_id, enable) ->
    dispatch op.set_tab_enable(tab_id, enable)
  o.on_set_enable_all = (enable) ->
    dispatch op.set_enable_all(enable)
  o

module.exports = compose(
  withStyles(styles, {
    name: 'PageTabList'
  })
  connect(mapStateToProps, mapDispatchToProps)
)(PageTabList)
