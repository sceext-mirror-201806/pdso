# privacy_note.coffee, pdso/src/lib/page_options/_tab_list/
React = require 'react'
PropTypes = require 'prop-types'
cC = require 'create-react-class'

{
  Typography
} = require '@material-ui/core'
# icons
{ default: Icons_WarningRounded } = require '@material-ui/icons/WarningRounded'

{
  gM
  lang_is_zh
} = require '../../util'
PaperM = require '../../ui/paper_m'


PrivacyNote = cC {
  displayName: 'TabList_PrivacyNote'
  propTypes: {
    classes: PropTypes.object.isRequired
  }

  _render_en: ->
    cl = @props.classes
    (
      <React.Fragment>
        <Typography className={ cl.p }>
          The page snapshot file saved by this program may contain some personal data.
          So please check what data is included before share the snapshot with others.
        </Typography>
        <Typography className={ cl.p }>
          This program will not send any data to network,
           it will only store all the collected data in the local page snapshot file.
          So how to handle the data, it&apos;s up to you.
        </Typography>
        <Typography className={ cl.p }>
          <strong>Suggestions:</strong>
          Use the <code>Private Browsing</code> (incognito) function of Firefox
            and do not login any online account will help to reduce the risk.
          But there is still some risk.
        </Typography>
      </React.Fragment>
    )

  _render_zh_CN: ->
    cl = @props.classes
    (
      <React.Fragment>
        <Typography className={ cl.p }>
          <strong>注意:</strong>
          使用本程序保存的页面快照文件中可能会包含一些个人隐私数据.
          所以, 将保存的页面快照分享给别人之前, 请检查其中包含了哪些数据.
        </Typography>
        <Typography className={ cl.p }>
          本程序不会将任何数据通过网络发送,
           只会把收集到的所有数据保存在本地的页面快照文件中.
          如何处理这些数据, 这取决于你自己.
        </Typography>
        <Typography className={ cl.p }>
          <strong>建议:</strong>
          使用 Firefox 的 <code>隐私浏览模式</code> 功能, 并且不登录任何在线账户,
           有助于减小这种风险.
          但是风险仍然存在.
        </Typography>
      </React.Fragment>
    )

  _render_content: ->
    if lang_is_zh()
      @_render_zh_CN()
    else
      @_render_en()

  render: ->
    (
      <PaperM class_name={ @props.classes.paper_note }>
        <div className={ @props.classes.note }>
          <div className={ @props.classes.note_left }>
            <Icons_WarningRounded color="error" fontSize="inherit" />
          </div>
          <div className={ @props.classes.note_right }>
            <Typography variant="headline" component="h3">
              { gM 'pot_privacy_note' }
            </Typography>
            { @_render_content() }
          </div>
        </div>
      </PaperM>
    )
}

module.exports = PrivacyNote
