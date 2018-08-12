# tab_list.coffee, pdso/src/lib/page_options/
React = require 'react'
PropTypes = require 'prop-types'
cC = require 'create-react-class'
{ compose } = require 'recompose'

{ withStyles } = require '@material-ui/core/styles'
{
  Paper
  Typography
  List
  CircularProgress
} = require '@material-ui/core'

OneItem = require './_tab_list/one_item'
PrivacyNote = require './_tab_list/privacy_note'
EnableAll = require './_tab_list/enable_all'
Config = require './_tab_list/config'


TabList = cC {
  displayName: 'TabList'
  propTypes: {
    classes: PropTypes.object.isRequired

    # tab_list data to render
    g: PropTypes.object.isRequired
    disable_tab: PropTypes.object.isRequired
    jszip_level: PropTypes.number.isRequired

    on_set_tab_enable: PropTypes.func.isRequired
    on_set_enable_all: PropTypes.func.isRequired
    on_snapshot: PropTypes.func.isRequired
    on_favicon_load_err: PropTypes.func.isRequired
    on_set_jszip_level: PropTypes.func.isRequired
  }

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
            disabled={ @props.disable_tab[i] }
            on_set_tab_enable={ @props.on_set_tab_enable }
            on_snapshot={ @props.on_snapshot }
            on_favicon_load_err={ @props.on_favicon_load_err }
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

  render: ->
    (
      <div className={ @props.classes.root }>
        { @_render_list() }
        <PrivacyNote classes={ @props.classes } />
        <EnableAll
          classes={ @props.classes }
          enable_all={ @props.g.enable_all }
          on_set_enable_all={ @props.on_set_enable_all }
        />
        <Config
          classes={ @props.classes }
          jszip_level={ @props.jszip_level }
          on_set_jszip_level={ @props.on_set_jszip_level }
        />
      </div>
    )
}

styles = require './_tab_list/styles'

# for redux
{ connect } = require 'react-redux'

action = require './redux/action'
op = require './redux/op'

mapStateToProps = ($$state, props) ->
  {
    g: $$state.get('g').toJS()
    disable_tab: $$state.get('disable_tab').toJS()
    jszip_level: $$state.getIn ['config', 'pdso_jszip_level']
  }

mapDispatchToProps = (dispatch, props) ->
  o = Object.assign {}, props

  o.on_set_tab_enable = (tab_id, enable) ->
    dispatch op.set_tab_enable(tab_id, enable)
  o.on_set_enable_all = (enable) ->
    dispatch op.set_enable_all(enable)
  o.on_snapshot = (tab_id) ->
    dispatch op.snapshot_one(tab_id)
  o.on_favicon_load_err = (tab_id, u) ->
    dispatch op.add_favicon_blacklist(tab_id, u)
  o.on_set_jszip_level = (level) ->
    dispatch op.set_jszip_level(level)
  o

module.exports = compose(
  withStyles(styles, {
    name: 'TabList'
  })
  connect(mapStateToProps, mapDispatchToProps)
)(TabList)
