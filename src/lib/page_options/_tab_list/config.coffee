# config.coffee, pdso/src/lib/page_options/_tab_list/
React = require 'react'
PropTypes = require 'prop-types'
cC = require 'create-react-class'

{
  Typography
  List
  ListItem
  ListItemText
  ListItemSecondaryAction
  Select
  MenuItem
} = require '@material-ui/core'

{
  JSZIP_LEVEL_NO
  JSZIP_LEVEL_MIN
  JSZIP_LEVEL_MAX
} = require '../../config'
{
  gM
} = require '../../util'
PaperM = require '../../ui/paper_m'


Config = cC {
  displayName: 'TabList_Config'
  propTypes: {
    classes: PropTypes.object.isRequired

    jszip_level: PropTypes.number.isRequired
    on_set_jszip_level: PropTypes.func.isRequired
  }

  _on_select_change: (event) ->
    level = Number.parseInt event.target.value
    @props.on_set_jszip_level level

  _render_level_list: ->
    to = []
    to.push JSZIP_LEVEL_NO
    for i in [JSZIP_LEVEL_MIN .. JSZIP_LEVEL_MAX]
      to.push i

    o = []
    for i in to
      o.push(
        <MenuItem key={ i } value={i}>{ "#{i}" }</MenuItem>
      )
    o

  _render_jszip_level: ->
    (
      <List>
        <ListItem>
          <ListItemText
            className={ @props.classes.item_text }
            primary={ gM 'pot_config_jszip_level' }
            secondary={ gM 'pot_config_jszip_level_desc' }
          />
          <ListItemSecondaryAction>
            <Select
              value={ @props.jszip_level }
              onChange={ @_on_select_change }
            >
              { @_render_level_list() }
            </Select>
          </ListItemSecondaryAction>
        </ListItem>
      </List>
    )

  render: ->
    (
      <PaperM class_name={ @props.classes.paper_config }>
        <Typography variant="headline" component="h3">
          { gM 'pot_config' }
        </Typography>
        { @_render_jszip_level() }
      </PaperM>
    )
}

module.exports = Config
