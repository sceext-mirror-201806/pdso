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
  P_VERSION
} = require '../config'
{
  gM
  lang_is_zh
} = require '../util'
PaperM = require '../ui/paper_m'


LICENSE_TEXT = """\
pdso: Page DOM Snapshot for Offline
Copyright (C) 2018  sceext

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
"""

LOGO_IMG = '../img/pdso-logo.svg'
HOMEPAGE_URL = 'https://bitbucket.org/eisf/pdso/'


TabAbout = cC {
  displayName: 'TabAbout'
  propTypes: {
    classes: PropTypes.object.isRequired
  }

  _render_logo: ->
    (
      <img src={ LOGO_IMG } alt="pdso logo" />
    )

  _render_en: ->
    cl = @props.classes
    (
      <React.Fragment>
        <PaperM>
          <div className={ cl.top }>
            <div className={ cl.left }>
              <Typography variant="headline" component="h3">
                pdso: Page DOM Snapshot for Offline
              </Typography>
              <Typography className={ [ cl.p, cl.a ] }>
                <a href={ HOMEPAGE_URL }>{ HOMEPAGE_URL }</a>
              </Typography>

              <Typography className={ [ cl.p, cl.version ] }>
                <code>{ P_VERSION }</code>
              </Typography>

              <Typography className={ cl.p }>
                (An extension for <strong>Desktop</strong> and
                <strong>Android</strong> <code>Firefox</code>)
              </Typography>
              <Typography className={ cl.p }>
                Take a static snapshot of the page DOM,
                (modify and) save it for offline viewing,
                including CSS styles and images, no script.
              </Typography>
            </div>
            <div className={ cl.right }>
              { @_render_logo() }
            </div>
          </div>
        </PaperM>

        <PaperM>
          <Typography variant="headline" component="h3">
            Features
          </Typography>
          <Typography className={ cl.p }>
            TODO
          </Typography>
        </PaperM>
      </React.Fragment>
    )

  _render_zh_CN: ->
    cl = @props.classes
    (
      <React.Fragment>
        <PaperM>
          <div className={ cl.top }>
            <div className={ cl.left }>
              <Typography variant="headline" component="h3">
                pdso 页面离线快照
              </Typography>
              <Typography className={ [ cl.p, cl.a ] }>
                <a href={ HOMEPAGE_URL }>{ HOMEPAGE_URL }</a>
              </Typography>

              <Typography className={ [ cl.p, cl.version ] }>
                (pdso: Page DOM Snapshot for Offline)
                <br />
                <code>{ P_VERSION }</code>
              </Typography>

              <Typography className={ cl.p }>
                (用于桌面和 Android 版 Firefox 的浏览器扩展. )
              </Typography>
              <Typography className={ cl.p }>
                对页面的 DOM 做一个静态快照, (修改并) 保存起来, 以供离线查看,
                包含 CSS 样式和图片, 不含脚本程序代码 (JavaScript).
              </Typography>
            </div>
            <div className={ cl.right }>
              { @_render_logo() }
            </div>
          </div>
        </PaperM>

        <PaperM>
          <Typography variant="headline" component="h3">
            特色
          </Typography>
          <Typography className={ cl.p }>
            TODO
          </Typography>
        </PaperM>
      </React.Fragment>
    )

  _render_content: ->
    if lang_is_zh()
      @_render_zh_CN()
    else
      @_render_en()

  _render_license: ->
    <PaperM>
      <Typography variant="headline" component="h3">LICENSE</Typography>
      <pre className={ @props.classes.license }>{ LICENSE_TEXT }</pre>
    </PaperM>

  render: ->
    (
      <div className={ @props.classes.root }>
        { @_render_content() }
        { @_render_license() }
      </div>
    )
}

styles = (theme) ->
  {
    license: {
      marginTop: theme.spacing.unit
      padding: theme.spacing.unit
      marginBottom: 0
      overflow: 'auto'
      color: theme.tb.color_sec
      backgroundColor: theme.tb.color_bg_sec
    }
    p: {
      marginTop: theme.spacing.unit
      marginBottom: theme.spacing.unit
    }
    a: {
      '& a': {
        color: theme.palette.text.secondary
      }
      '& a:visited': {
        color: theme.palette.text.secondary
      }
    }
    version: {
      color: theme.palette.text.secondary
    }

    # for show logo
    top: {
      display: 'flex'
    }
    left: {
      flex: 1
    }
    right: {
      marginLeft: theme.spacing.unit
      '& img': {
        width: '12em'
      }
    }
  }

# for redux
{ connect } = require 'react-redux'

action = require './redux/action'
op = require './redux/op'

mapStateToProps = ($$state, props) ->
  {}

mapDispatchToProps = (dispatch, props) ->
  o = Object.assign {}, props
  o

module.exports = compose(
  withStyles(styles, {
    name: 'TabAbout'
  })
  connect(mapStateToProps, mapDispatchToProps)
)(TabAbout)
