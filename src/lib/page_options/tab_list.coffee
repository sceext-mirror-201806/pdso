# page_tab_list.coffee, pdso/src/lib/page_options/
React = require 'react'
PropTypes = require 'prop-types'
cC = require 'create-react-class'
{ compose } = require 'recompose'

{ withStyles } = require '@material-ui/core/styles'
{
  Paper
  Typography
  Switch
  List
  ListItem
  ListItemText
  ListItemSecondaryAction
  Avatar
  Chip
  Tooltip
  CircularProgress
  IconButton
  Badge
} = require '@material-ui/core'
Icons = require '@material-ui/icons'
IconM = require 'mdi-material-ui'

{
  gM
} = require '../util'
PaperM = require '../ui/paper_m'


OneItem = cC {
  displayName: 'PageTabList_OneItem'
  propTypes: {
    classes: PropTypes.object.isRequired
    g: PropTypes.object.isRequired
    tab_id: PropTypes.string.isRequired

    on_set_tab_enable: PropTypes.func.isRequired
    on_snapshot: PropTypes.func.isRequired
  }

  _on_toggle: ->
    @props.on_set_tab_enable(@props.tab_id, ! @_get_enable())

  _on_snapshot: ->
    @props.on_snapshot @props.tab_id

  _get_one: ->
    @props.g.list[@props.tab_id]

  _get_enable: ->
    if @props.g.enable[@props.tab_id]
      true
    else
      false

  _get_reset: ->
    one = @_get_one()
    if ! one.rc?
      return false  # no rc, no reset
    if one.rc.after_reset
      true
    else
      false

  _get_switch_tooltip: ->
    if @_get_enable()
      gM 'pot_switch_tooltip_enable'
    else
      gM 'pot_switch_tooltip_disable'

  _get_snapshot_tooltip: ->
    # check reset
    if @_get_reset()
      gM 'pot_snapshot_tooltip_reset'
    else
      gM 'pot_snapshot_tooltip_no_reset'

  _gen_title: ->
    one = @_get_one()
    if one.incognito
      gM 'pot_title_incognito', [
        one.title
      ]
    else
      one.title

  _render_second: ->
    one = @_get_one()
    (
      <React.Fragment>
        { one.url }
        <Tooltip
          title={ gM 'pot_tooltip_tab_id' }
          enterDelay={ 1000 }
          disableFocusListener
          placement="right"
        >
          <Chip
            label={ one.id }
            classes={{
              root: @props.classes.chip
              label: @props.classes.chip_label
            }}
          />
        </Tooltip>
      </React.Fragment>
    )

  _render_snapshot_button: ->
    # check page enabled
    if ! @_get_enable()
      return
    (
      <Tooltip
        title={ @_get_snapshot_tooltip() }
        enterDelay={ 300 }
        disableFocusListener
        placement="left"
      >
        <span>
          <IconButton disabled={ ! @_get_reset() } onClick={ @_on_snapshot } >
            <IconM.Download />
          </IconButton>
        </span>
      </Tooltip>
    )

  _render_avatar: ->
    one = @_get_one()
    # try render favicon
    if one.favicon_url?
      (
        <Avatar src={ one.favicon_url } />
      )
    else
      (
        <Avatar>
          <IconM.FileOutline />
        </Avatar>
      )

  _render_icon: ->
    # check rc.count
    if ! @_get_enable()
      count = 0
    else
      one = @_get_one()
      if ! one.rc?
        count = 0
      else
        count = one.rc.count

    if count > 0
      # TODO i18n
      (
        <Tooltip
          title={ gM 'pot_tooltip_res_number' }
          enterDelay={ 1000 }
          disableFocusListener
          placement="top"
        >
          <Badge
            badgeContent={ count }
            color="primary"
            classes={{
              badge: @props.classes.badge
            }}
          >
            { @_render_avatar() }
          </Badge>
        </Tooltip>
      )
    else
      @_render_avatar()

  render: ->
    (
      <ListItem>
        { @_render_icon() }
        <ListItemText
          className={ @props.classes.item_text }
          primary={ @_gen_title() }
          secondary={ @_render_second() }
        />
        <ListItemSecondaryAction>
          { @_render_snapshot_button() }
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
    on_snapshot: PropTypes.func.isRequired
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
            on_snapshot={ @props.on_snapshot }
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

  _render_text_n: (raw) ->
    o = []
    n = raw.split('\n')
    for i in [0... n.length]
      o.push(
        <Typography key={ i } className={ @props.classes.p }>
          { n[i] }
        </Typography>
      )
    o

  _render_privacy_note: ->
    (
      <PaperM class_name={ @props.classes.paper_note }>
        <div className={ @props.classes.note }>
          <div className={ @props.classes.note_left }>
            <Icons.WarningRounded color="error" fontSize="inherit" />
          </div>
          <div className={ @props.classes.note_right }>
            <Typography variant="headline" component="h3">
              { gM 'pot_privacy_note' }
            </Typography>
            { @_render_text_n gM('pot_privacy_note_text') }
          </div>
        </div>
      </PaperM>
    )

  _render_enable_all: ->
    (
      <PaperM class_name={ @props.classes.paper_enable_all }>
        <div className={ @props.classes.enable_all_title }>
          <Typography variant="headline" component="h3">
            { gM 'pot_enable_all' }
          </Typography>
          <Switch checked={ @props.g.enable_all } onChange={ @_on_toggle_enable_all } color="primary" />
        </div>
        { @_render_text_n gM('pot_enable_all_desc') }
      </PaperM>
    )

  render: ->
    (
      <div className={ @props.classes.root }>
        { @_render_list() }
        { @_render_privacy_note() }
        { @_render_enable_all() }
      </div>
    )
}

styles = (theme) ->
  {
    paper_list: {  # no padding
      margin: theme.spacing.unit
      marginTop: theme.spacing.unit * 2
    }
    paper_note: {
      backgroundColor: theme.tb.color_note
    }
    paper_enable_all: {
      paddingRight: '4px'
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
    item_text: {
      paddingRight: '72px'
    }
    badge: {
      width: 'auto'
      minWidth: '22px'
      borderRadius: '11px'
      paddingLeft: '6px'
      paddingRight: '6px'
    }
    note: {
      display: 'flex'
      alignItems: 'center'
    }
    note_left: {
      paddingRight: theme.spacing.unit * 2
      fontSize: '48px'
    }
    note_right: {
      flex: 1
    }
    p: {
      marginTop: theme.spacing.unit
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
  o.on_snapshot = (tab_id) ->
    # TODO
    console.log "FIXME: page_tab_list.on_snapshot, tab_id = #{tab_id}"
  o

module.exports = compose(
  withStyles(styles, {
    name: 'TabList'
  })
  connect(mapStateToProps, mapDispatchToProps)
)(PageTabList)
