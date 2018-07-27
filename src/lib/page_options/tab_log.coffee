# tab_log.coffee, pdso/src/lib/page_options/
React = require 'react'
PropTypes = require 'prop-types'
cC = require 'create-react-class'
{ compose } = require 'recompose'

{
  Typography
} = require '@material-ui/core'
{
  withStyles
} = require '@material-ui/core/styles'

{
  gM
  to_log_time
} = require '../util'
PaperM = require '../ui/paper_m'


TabLog = cC {
  displayName: 'TabLog'
  propTypes: {
    classes: PropTypes.object.isRequired
    log: PropTypes.array.isRequired
  }

  _render_log_item: (i) ->
    one = @props.log[i]
    time = to_log_time one.time
    # TODO rich style ?
    (
      <Typography className={ @props.classes.p }>
        <code>{ "[ #{time} ]" }</code>
        { one.text }
      </Typography>
    )

  _render_log: ->
    if @props.log.length < 1
      # no log
      (
        <Typography className={ @props.classes.no_log }>
          { gM 'po_no_log' }
        </Typography>
      )
    else
      # log list
      o = []
      for i in [0... @props.log.length]
        o.push @_render_log_item(i)
      o

  render: ->
    (
      <div className={ @props.classes.root }>
        <PaperM>
          { @_render_log() }
        </PaperM>
      </div>
    )
}

styles = (theme) ->
  {
    p: {
      marginTop: theme.spacing.unit
      marginBottom: theme.spacing.unit
      '& code': {
        marginRight: theme.spacing.unit
        color: theme.palette.text.secondary
      }
    }

    no_log: {
      color: theme.palette.text.secondary
    }
  }

# for redux
{ connect } = require 'react-redux'

action = require './redux/action'
op = require './redux/op'

mapStateToProps = ($$state, props) ->
  {
    log: $$state.get('log').toJS()
  }

mapDispatchToProps = (dispatch, props) ->
  o = Object.assign {}, props
  o

module.exports = compose(
  withStyles(styles, {
    name: 'TabLog'
  })
  connect(mapStateToProps, mapDispatchToProps)
)(TabLog)
