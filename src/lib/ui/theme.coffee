# theme.coffee, pdso/src/lib/ui/
React = require 'react'
PropTypes = require 'prop-types'
cC = require 'create-react-class'
{
  MuiThemeProvider
  createMuiTheme
} = require '@material-ui/core/styles'

{ default: blue } = require '@material-ui/core/colors/blue'
{ default: yellow } = require '@material-ui/core/colors/yellow'
{ default: grey } = require '@material-ui/core/colors/grey'

{
  UI_THEME_LIGHT
  UI_THEME_DARK
} = require '../config'


_light = createMuiTheme {
  palette: {
    type: 'light'

    background: {
      default: grey[200]
    }
  }
  # tab_list
  tb: {
    color_tab: blue[700]  # active tab text color
    color_note: yellow.A100  # privacy note background color
    color_sec: grey[800]  # second text (grey) color
    color_bg_sec: grey[300]  # second background (grey) color
  }
}

_dark = createMuiTheme {
  palette: {
    type: 'dark'
  }
  # tab_list
  tb: {
    color_tab: blue[200]
    color_note: blue[800]
    color_sec: grey[300]
    color_bg_sec: grey[900]
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
