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
  is_android
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

  _render_top_first: ->
    cl = @props.classes
    (
      <React.Fragment>
        <Typography variant="headline" component="h3">
          { gM 'po_about_title' }
        </Typography>
        <Typography className={ [ cl.p, cl.a ] }>
          <a href={ HOMEPAGE_URL }>{ HOMEPAGE_URL }</a>
        </Typography>

        <Typography className={ [ cl.p, cl.version ] }>
          <code>{ P_VERSION }</code>
        </Typography>
      </React.Fragment>
    )

  _render_top_second_en: ->
    cl = @props.classes
    (
      <React.Fragment>
        <Typography className={ cl.p }>
          Take a static snapshot of the page DOM,
          (modify and) save it for offline viewing,
          including CSS styles and images, no script.
        </Typography>
        <Typography className={ [ cl.p, cl.p_last ] }>
          (An extension for <strong>Desktop</strong> and {' '}
           <strong>Android</strong> <code>Firefox</code>)
        </Typography>
      </React.Fragment>
    )

  _render_top_second_zh_CN: ->
    cl = @props.classes
    (
      <div className={ cl.first }>
        <Typography className={ cl.p }>
          对页面的 DOM 做一个静态快照, (修改并) 保存起来, 以供离线查看,
          包含 CSS 样式和图片, 不含脚本程序代码 (JavaScript).
        </Typography>
        <Typography className={ [ cl.p, cl.p_last ] }>
          (用于桌面和 Android 版 Firefox 的浏览器扩展. )
        </Typography>
      </div>
    )

  _render_top_second: ->
    if lang_is_zh()
      @_render_top_second_zh_CN()
    else
      @_render_top_second_en()

  _render_top_desktop: ->
    cl = @props.classes
    (
      <div className={ cl.top }>
        <div className={ cl.left }>
          { @_render_top_first() }
          { @_render_top_second() }
        </div>
        <div className={ cl.right }>
          { @_render_logo() }
        </div>
      </div>
    )

  _render_top_android: ->
    cl = @props.classes
    (
      <div className={ cl.top_android }>
        { @_render_top_first() }
        <div className={ cl.logo_android }>
          { @_render_logo() }
        </div>
        { @_render_top_second() }
      </div>
    )

  _render_top: ->
    if is_android()
      @_render_top_android()
    else
      @_render_top_desktop()

  _render_en: ->
    cl = @props.classes
    (
      <React.Fragment>
        <PaperM>
          <Typography variant="headline" component="h3">
            Features
          </Typography>
          <div className={ cl.feature }>
            <Typography className={ cl.p }>
              <strong>+</strong> Take a static snapshot of the dynamic page,
                and save it as HTML, not picture.
            </Typography>
            <Typography className={ cl.p }>
              <strong>+</strong> Keep all the styles and images, what you see is what you get.
            </Typography>
            <Typography className={ cl.p }>
              <strong>+</strong> Remove all the scripts in saved HTML.
            </Typography>
            <Typography className={ cl.p }>
              <strong>+</strong> Pack all the files (the HTML file, images, CSS files)
                in a zip archive.
            </Typography>
          </div>

          <Typography variant="headline" component="h4" className={ cl.h2 }>
            Suggestions
          </Typography>
          <Typography className={ cl.p2 }>
            Please use the latest Firefox to view the saved snapshot to get the
              best display effect.
          </Typography>

          <Typography variant="headline" component="h4" className={ cl.h2 }>
            Known issues
          </Typography>
          <Typography className={ cl.p2 }>
            Currently this program can not pack all the resources of a page,
             and can not deal with all the circumstances.
            So the snapshot may look some what different from the original page.
          </Typography>
        </PaperM>
      </React.Fragment>
    )

  _render_zh_CN: ->
    cl = @props.classes
    (
      <React.Fragment>
        <PaperM>
          <Typography variant="headline" component="h3">
            特色
          </Typography>
          <div className={ cl.feature }>
            <Typography className={ cl.p }>
              <strong>+</strong> 获取动态页面的静态快照, 并将其保存为 HTML, 而不是图片.
            </Typography>
            <Typography className={ cl.p }>
              <strong>+</strong> 保留所有页面样式和图片, 保存的页面就和你当时看到的一样.
            </Typography>
            <Typography className={ cl.p }>
              <strong>+</strong> 保存之前移除页面中的所有脚本程序代码 (JavaScript).
            </Typography>
            <Typography className={ cl.p }>
              <strong>+</strong> 将所有文件 (HTML 文件, 图片, CSS 文件) 打包保存在一个 zip 压缩包中.
            </Typography>
          </div>

          <Typography variant="headline" component="h4" className={ cl.h2 }>
            建议
          </Typography>
          <Typography className={ cl.p2 }>
            请使用最新版 Firefox 浏览器查看保存的快照, 以便获得最佳显示效果.
          </Typography>

          <Typography variant="headline" component="h4" className={ cl.h2 }>
            已知问题
          </Typography>
          <Typography className={ cl.p2 }>
            目前本程序无法打包页面的所有资源, 并不能处理所有情况.
            所以快照可能看起来与原始页面有一些区别.
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
    cl = @props.classes
    c = cl.license
    if is_android()
      c = "#{cl.license} #{cl.android}"

    <PaperM>
      <Typography variant="headline" component="h3">LICENSE</Typography>
      <pre className={ c }>{ LICENSE_TEXT }</pre>
    </PaperM>

  render: ->
    (
      <div className={ @props.classes.root }>
        <PaperM>
          { @_render_top() }
        </PaperM>
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
      color: theme.tb.color_sec
      backgroundColor: theme.tb.color_bg_sec
      whiteSpace: 'pre-wrap'

      '&$android': {
        fontSize: '0.8em'
      }
    }
    android: {}

    first: {
      '& p': {
        letterSpacing: '0.05em'
        wordSpacing: '0.05em'
        marginTop: theme.spacing.unit * 2
        marginBottom: 0
        lineHeight: '1.8em'
      }
      '& $p_last': {
        marginTop: theme.spacing.unit
      }
    }
    feature: {
      '& p': {
        fontSize: '1.05em'
        paddingLeft: '2em'
        textIndent: '-1.2em'
        marginTop: theme.spacing.unit * 1.2
        marginBottom: 0
        letterSpacing: '0.05em'
        wordSpacing: '0.05em'
        lineHeight: '1.8em'
      }
      '& strong': {
        color: theme.palette.text.secondary
        paddingRight: '0.2em'
        fontWeight: 'normal'
      }
    }
    p: {
      marginTop: theme.spacing.unit
      marginBottom: theme.spacing.unit
    }
    p_last: {}

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

    top_android: {}
    logo_android: {
      display: 'flex'
      justifyContent: 'center'
      '& img': {
        width: '16em'
      }
    }

    p2: {
      marginTop: theme.spacing.unit * 1.5
      marginBottom: 0
    }
    h2: {
      fontSize: '1.3rem'
      marginTop: theme.spacing.unit * 2
      marginBottom: 0
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
