# paper_m.coffee, pdso/src/lib/ui/
React = require 'react'
PropTypes = require 'prop-types'
cC = require 'create-react-class'

{ withStyles } = require '@material-ui/core/styles'
{
  Paper
} = require '@material-ui/core'


PaperM = cC {
  displayName: 'PaperM'
  propTypes: {
    classes: PropTypes.object.isRequired
    children: PropTypes.node
    class_name: PropTypes.string
  }

  render: ->
    (
      <div className={ @props.classes.root }>
        <Paper className={ [ @props.classes.paper, @props.class_name ] }>
          { @props.children }
        </Paper>
      </div>
    )
}

styles = (theme) ->
  {
    paper: {
      padding: theme.spacing.unit * 2
      margin: theme.spacing.unit
      marginTop: theme.spacing.unit * 2
    }
  }

module.exports = withStyles(styles, {
  name: 'PaperM'
})(PaperM)
