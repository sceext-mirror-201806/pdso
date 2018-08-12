# one_item.coffee, pdso/src/lib/page_options/_tab_list/
React = require 'react'
PropTypes = require 'prop-types'
cC = require 'create-react-class'

{
  Switch
  ListItem
  ListItemText
  ListItemSecondaryAction
  Avatar
  Chip
  Tooltip
  IconButton
  Badge
} = require '@material-ui/core'
# icons
{ default: IconM_Download } = require 'mdi-material-ui/Download'
{ default: IconM_FileOutline } = require 'mdi-material-ui/FileOutline'

{
  gM

  is_url_disabled
  is_newtab
} = require '../../util'


OneItem = cC {
  displayName: 'TabList_OneItem'
  propTypes: {
    classes: PropTypes.object.isRequired
    g: PropTypes.object.isRequired
    tab_id: PropTypes.string.isRequired
    disabled: PropTypes.bool

    on_set_tab_enable: PropTypes.func.isRequired
    on_snapshot: PropTypes.func.isRequired
    on_favicon_load_err: PropTypes.func.isRequired
  }

  _on_toggle: ->
    @props.on_set_tab_enable(@props.tab_id, ! @_get_enable())

  _on_favicon_load_err: ->
    one = @_get_one()
    @props.on_favicon_load_err @props.tab_id, one.favicon_url

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

  _is_url_disabled: ->
    one = @_get_one()
    is_url_disabled one.url

  _is_newtab: ->
    one = @_get_one()
    is_newtab one.url

  _get_switch_tooltip: ->
    if @props.disabled
      gM 'pot_disable_tooltip_snapshot_doing'
    else if @_get_enable()
      gM 'pot_switch_tooltip_enable'
    else if @_is_url_disabled() and (! @_is_newtab())
      gM 'pot_switch_tooltip_url_disabled'
    else
      gM 'pot_switch_tooltip_disable'

  _get_snapshot_tooltip: ->
    # check reset
    if @props.disabled
      gM 'pot_disable_tooltip_snapshot_doing'
    else if @_is_url_disabled()
      gM 'pot_switch_tooltip_url_disabled'
    else if @_get_reset()
      gM 'pot_snapshot_tooltip_reset'
    else
      gM 'pot_snapshot_tooltip_no_reset'

  _render_title: ->
    one = @_get_one()
    if one.incognito
      (
        <React.Fragment>
          <span className={ @props.classes.incognito }>
            { gM 'pot_title_incognito' }
          </span>
          { one.title }
        </React.Fragment>
      )
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
    # check disabled
    disabled = false
    if ! @_get_reset()
      disabled = true
    if @props.disabled
      disabled = true
    if @_is_url_disabled()
      disabled = true
    (
      <Tooltip
        title={ @_get_snapshot_tooltip() }
        enterDelay={ 300 }
        disableFocusListener
        placement="left"
      >
        <span>
          <IconButton disabled={ disabled } onClick={ @_on_snapshot } >
            <IconM_Download />
          </IconButton>
        </span>
      </Tooltip>
    )

  _render_avatar: ->
    one = @_get_one()
    # check blacklist
    u = one.favicon_url
    if u?
      if one.favicon_url_blacklist.indexOf(u) != -1
        u = null
    if u?
      (
        <Avatar src={ u } onError={ @_on_favicon_load_err } />
      )
    else
      (
        <Avatar>
          <IconM_FileOutline />
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
    # check switch disabled
    disabled = false
    if @props.disabled
      disabled = true
    if @_is_url_disabled() and (! @_is_newtab())
      disabled = true
    (
      <ListItem>
        { @_render_icon() }
        <ListItemText
          className={ @props.classes.item_text }
          primary={ @_render_title() }
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
            <span>
              <Switch
                checked={ @_get_enable() }
                onChange={ @_on_toggle }
                color="primary"
                disabled={ disabled }
              />
            </span>
          </Tooltip>
        </ListItemSecondaryAction>
      </ListItem>
    )
}

module.exports = OneItem
