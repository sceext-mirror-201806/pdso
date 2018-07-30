# page_tab_list.coffee, pdso/src/lib/page_options/
React = require 'react'
PropTypes = require 'prop-types'
cC = require 'create-react-class'
{ compose } = require 'recompose'

{ withStyles } = require '@material-ui/core/styles'
{
  Paper
  Typography
  Switch
  List
  ListItem
  ListItemText
  ListItemSecondaryAction
  Avatar
  Chip
  Tooltip
  CircularProgress
  IconButton
  Badge
} = require '@material-ui/core'
# icons
{ default: Icons_WarningRounded } = require '@material-ui/icons/WarningRounded'
{ default: IconM_Download } = require 'mdi-material-ui/Download'
{ default: IconM_FileOutline } = require 'mdi-material-ui/FileOutline'

{
  gM
  lang_is_zh

  is_url_disabled
  is_newtab
} = require '../util'
PaperM = require '../ui/paper_m'


OneItem = cC {
  displayName: 'PageTabList_OneItem'
  propTypes: {
    classes: PropTypes.object.isRequired
    g: PropTypes.object.isRequired
    tab_id: PropTypes.string.isRequired
    disabled: PropTypes.bool

    on_set_tab_enable: PropTypes.func.isRequired
    on_snapshot: PropTypes.func.isRequired
    on_favicon_load_err: PropTypes.func.isRequired
  }

  _on_toggle: ->
    @props.on_set_tab_enable(@props.tab_id, ! @_get_enable())

  _on_favicon_load_err: ->
    one = @_get_one()
    @props.on_favicon_load_err @props.tab_id, one.favicon_url

  _on_snapshot: ->
    @props.on_snapshot @props.tab_id

  _get_one: ->
    @props.g.list[@props.tab_id]

  _get_enable: ->
    if @props.g.enable[@props.tab_id]
      true
    else
      false

  _get_reset: ->
    one = @_get_one()
    if ! one.rc?
      return false  # no rc, no reset
    if one.rc.after_reset
      true
    else
      false

  _is_url_disabled: ->
    one = @_get_one()
    is_url_disabled one.url

  _is_newtab: ->
    one = @_get_one()
    is_newtab one.url

  _get_switch_tooltip: ->
    if @props.disabled
      gM 'pot_disable_tooltip_snapshot_doing'
    else if @_get_enable()
      gM 'pot_switch_tooltip_enable'
    else if @_is_url_disabled() and (! @_is_newtab())
      gM 'pot_switch_tooltip_url_disabled'
    else
      gM 'pot_switch_tooltip_disable'

  _get_snapshot_tooltip: ->
    # check reset
    if @props.disabled
      gM 'pot_disable_tooltip_snapshot_doing'
    else if @_is_url_disabled()
      gM 'pot_switch_tooltip_url_disabled'
    else if @_get_reset()
      gM 'pot_snapshot_tooltip_reset'
    else
      gM 'pot_snapshot_tooltip_no_reset'

  _render_title: ->
    one = @_get_one()
    if one.incognito
      (
        <React.Fragment>
          <span className={ @props.classes.incognito }>
            { gM 'pot_title_incognito' }
          </span>
          { one.title }
        </React.Fragment>
      )
    else
      one.title

  _render_second: ->
    one = @_get_one()
    (
      <React.Fragment>
        { one.url }
        <Tooltip
          title={ gM 'pot_tooltip_tab_id' }
          enterDelay={ 1000 }
          disableFocusListener
          placement="right"
        >
          <Chip
            label={ one.id }
            classes={{
              root: @props.classes.chip
              label: @props.classes.chip_label
            }}
          />
        </Tooltip>
      </React.Fragment>
    )

  _render_snapshot_button: ->
    # check page enabled
    if ! @_get_enable()
      return
    # check disabled
    disabled = false
    if ! @_get_reset()
      disabled = true
    if @props.disabled
      disabled = true
    if @_is_url_disabled()
      disabled = true
    (
      <Tooltip
        title={ @_get_snapshot_tooltip() }
        enterDelay={ 300 }
        disableFocusListener
        placement="left"
      >
        <span>
          <IconButton disabled={ disabled } onClick={ @_on_snapshot } >
            <IconM_Download />
          </IconButton>
        </span>
      </Tooltip>
    )

  _render_avatar: ->
    one = @_get_one()
    # check blacklist
    u = one.favicon_url
    if u?
      if one.favicon_url_blacklist.indexOf(u) != -1
        u = null
    if u?
      (
        <Avatar src={ u } onError={ @_on_favicon_load_err } />
      )
    else
      (
        <Avatar>
          <IconM_FileOutline />
        </Avatar>
      )

  _render_icon: ->
    # check rc.count
    if ! @_get_enable()
      count = 0
    else
      one = @_get_one()
      if ! one.rc?
        count = 0
      else
        count = one.rc.count

    if count > 0
      (
        <Tooltip
          title={ gM 'pot_tooltip_res_number' }
          enterDelay={ 1000 }
          disableFocusListener
          placement="top"
        >
          <Badge
            badgeContent={ count }
            color="primary"
            classes={{
              badge: @props.classes.badge
            }}
          >
            { @_render_avatar() }
          </Badge>
        </Tooltip>
      )
    else
      @_render_avatar()

  render: ->
    # check switch disabled
    disabled = false
    if @props.disabled
      disabled = true
    if @_is_url_disabled() and (! @_is_newtab())
      disabled = true
    (
      <ListItem>
        { @_render_icon() }
        <ListItemText
          className={ @props.classes.item_text }
          primary={ @_render_title() }
          secondary={ @_render_second() }
        />
        <ListItemSecondaryAction>
          { @_render_snapshot_button() }
          <Tooltip
            title={ @_get_switch_tooltip() }
            enterDelay={ 1000 }
            disableFocusListener
            placement="left"
          >
            <span>
              <Switch
                checked={ @_get_enable() }
                onChange={ @_on_toggle }
                color="primary"
                disabled={ disabled }
              />
            </span>
          </Tooltip>
        </ListItemSecondaryAction>
      </ListItem>
    )
}

PageTabList = cC {
  displayName: 'PageTabList'
  propTypes: {
    classes: PropTypes.object.isRequired

    # tab_list data to render
    g: PropTypes.object.isRequired
    disable_tab: PropTypes.object.isRequired

    on_set_tab_enable: PropTypes.func.isRequired
    on_set_enable_all: PropTypes.func.isRequired
    on_snapshot: PropTypes.func.isRequired
    on_favicon_load_err: PropTypes.func.isRequired
  }

  _on_toggle_enable_all: ->
    @props.on_set_enable_all(! @props.g.enable_all)

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

  _render_privacy_note_content_en: ->
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

  _render_privacy_note_content_zh_CN: ->
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

  _render_privacy_note_content: ->
    if lang_is_zh()
      @_render_privacy_note_content_zh_CN()
    else
      @_render_privacy_note_content_en()

  _render_privacy_note: ->
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
            { @_render_privacy_note_content() }
          </div>
        </div>
      </PaperM>
    )

  _render_enable_all_desc_en: ->
    cl = @props.classes
    (
      <div className={ cl.enable_all_desc }>
        <Typography>
          To keep the appearance of the page,
           we should not only save the HTML of the page DOM,
           but also different referenced resources in the document,
           such as images, CSS files, etc.
          To able to save these resources,
           this program records all the resources loaded by a page in the background.
          After <code>enable the tab</code>, this program will record those pages.
          (No record when disabled. )
        </Typography>
        <Typography>
          Recording all the resources loaded by pages may consume a great deal of memory,
           and slow down the whole browser.
          So this program disables each tab by default.
          You must enable the tab by hand before a snapshot.
        </Typography>
        <Typography>
          To avoid leaving out some resources,
           the recording must start before the page starts load.
          So after enable a tab but before the page reset (such as refresh),
           a snapshot can not be performed.
          You usually need to refresh by hand before a snapshot.
        </Typography>
        <Typography>
          But if the tab is enabaled by default,
           you can snapshot any time without refresh first,
           because this program is always recording all the resources.
          So this option is actually a choose between convenience (enabled by default)
            or speed and efficiency (disabled by default).
        </Typography>
      </div>
    )

  _render_enable_all_desc_zh_CN: ->
    cl = @props.classes
    (
      <div className={ cl.enable_all_desc }>
        <Typography>
          为了使保存的页面和当时看到的一样, 除了保存页面 DOM 对应的 HTML 之外,
           还要把其中引用的各种相关资源一并保存起来, 比如图片, CSS 样式文件, 等.
          为了能够保存这些资源, 本程序需要在后台默默记录一个页面加载的所有资源. {' '}
          <code>启用标签页</code> 后, 本程序就会对相应页面进行记录.
          (禁用时不会记录. )
        </Typography>
        <Typography>
          记录页面加载的所有资源可能会消耗大量内存, 并拖慢浏览器的整体运行速度,
           所以本程序默认禁用每个标签页, 快照之前需要手动启用相应标签页.
        </Typography>
        <Typography>
          为了避免漏掉资源, 必须从页面一开始加载时, 就进行相应记录.
          也就是说, 启用页面后但页面重置 (比如刷新) 之前, 不能进行快照.
          所以, 启用页面之后, 通常需要手动刷新页面, 才能快照.
        </Typography>
        <Typography className={ cl.last }>
          而如果默认启用了标签页, 由于本程序始终在记录加载的资源, 也就无需手动刷新,
           随时进行快照.
          所以, 本功能其实是在使用方便 (默认启用) 和速度效率 (默认禁用) 之间做出选择.
        </Typography>
      </div>
    )

  _render_enable_all_desc: ->
    if lang_is_zh()
      @_render_enable_all_desc_zh_CN()
    else
      @_render_enable_all_desc_en()

  _render_enable_all: ->
    (
      <PaperM class_name={ @props.classes.paper_enable_all }>
        <div className={ @props.classes.enable_all_title }>
          <Typography variant="headline" component="h3">
            { gM 'pot_enable_all' }
          </Typography>
          <Switch checked={ @props.g.enable_all } onChange={ @_on_toggle_enable_all } color="primary" />
        </div>
        { @_render_enable_all_desc() }
      </PaperM>
    )

  render: ->
    (
      <div className={ @props.classes.root }>
        { @_render_list() }
        { @_render_privacy_note() }
        { @_render_enable_all() }
      </div>
    )
}

styles = (theme) ->
  {
    paper_list: {  # no padding
      margin: theme.spacing.unit
      marginTop: theme.spacing.unit * 2
    }
    paper_note: {
      backgroundColor: theme.tb.color_note
    }
    paper_enable_all: {
      paddingRight: '4px'
    }
    enable_all_title: {
      display: 'flex'

      '& h3': {
        flex: 1
      }
    }
    chip: {
      marginLeft: theme.spacing.unit
      height: 'auto'
      cursor: 'auto'
      color: 'inherit'
    }
    chip_label: {
      display: 'initial'
      userSelect: 'auto'
      textAlign: 'center'
    }
    placeholder: {
      padding: theme.spacing.unit * 2
      display: 'flex'
      justifyContent: 'center'
    }
    item_text: {
      paddingRight: '72px'
    }
    badge: {
      width: 'auto'
      minWidth: '22px'
      borderRadius: '11px'
      paddingLeft: '6px'
      paddingRight: '6px'
    }
    note: {
      display: 'flex'
      alignItems: 'center'
    }
    note_left: {
      paddingRight: theme.spacing.unit * 2
      fontSize: '48px'
    }
    note_right: {
      flex: 1
    }
    p: {
      marginTop: theme.spacing.unit
      '& strong': {
        paddingRight: theme.spacing.unit
      }
      '& code': {
        backgroundColor: theme.palette.background.default
      }
    }
    incognito: {
      color: theme.palette.text.secondary
      paddingRight: theme.spacing.unit
    }
    enable_all_desc: {
      paddingRight: theme.spacing.unit
      '& p': {
        marginTop: theme.spacing.unit
        marginBottom: theme.spacing.unit * 1.5
        lineHeight: '1.7em'
        '& code': {
          backgroundColor: theme.palette.background.default
        }
        '&$last': {
          marginBottom: 0
        }
      }
    }
    last: {}
  }

# for redux
{ connect } = require 'react-redux'

action = require './redux/action'
op = require './redux/op'

mapStateToProps = ($$state, props) ->
  {
    g: $$state.get('g').toJS()
    disable_tab: $$state.get('disable_tab').toJS()
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
  o

module.exports = compose(
  withStyles(styles, {
    name: 'TabList'
  })
  connect(mapStateToProps, mapDispatchToProps)
)(PageTabList)
