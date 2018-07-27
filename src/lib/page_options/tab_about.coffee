# tab_about.coffee, pdso/src/lib/page_options/
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
} = require '../util'
PaperM = require '../ui/paper_m'


TabAbout = cC {
  displayName: 'TabAbout'
  propTypes: {
    classes: PropTypes.object.isRequired

    # TODO
  }

  render: ->
    (
      <div className={ @props.classes.root }>
        <PaperM>
          <Typography>
            TODO about
          </Typography>
        </PaperM>
      </div>
    )
}

styles = (theme) ->
  {
    # TODO
  }

# for redux
{ connect } = require 'react-redux'

action = require './redux/action'
op = require './redux/op'

mapStateToProps = ($$state, props) ->
  {
    # TODO
  }

mapDispatchToProps = (dispatch, props) ->
  o = Object.assign {}, props

  # TODO
  o

module.exports = compose(
  withStyles(styles, {
    name: 'TabAbout'
  })
  connect(mapStateToProps, mapDispatchToProps)
)(TabAbout)
