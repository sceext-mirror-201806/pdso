# theme.coffee, pdso/src/lib/ui/
React = require 'react'
PropTypes = require 'prop-types'
cC = require 'create-react-class'
{
  MuiThemeProvider
  createMuiTheme
} = require '@material-ui/core/styles'

{
  UI_THEME_LIGHT
  UI_THEME_DARK
} = require '../config'


_light = createMuiTheme {
  palette: {
    type: 'light'
  }
}

_dark = createMuiTheme {
  palette: {
    type: 'dark'
  }
}


Theme = cC {
  displayName: 'Theme'
  propTypes: {
    theme: PropTypes.string
    children: PropTypes.node
  }

  render: ->
    if @props.theme is UI_THEME_DARK
      theme = _dark
    else  # default theme is light
      theme = _light

    (
      <MuiThemeProvider theme={ theme }>
        { @props.children }
      </MuiThemeProvider>
    )
}

module.exports = Theme
