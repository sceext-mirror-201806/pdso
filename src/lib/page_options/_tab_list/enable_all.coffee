# enable_all.coffee, pdso/src/lib/page_options/_tab_list/
React = require 'react'
PropTypes = require 'prop-types'
cC = require 'create-react-class'

{
  Typography
  Switch
} = require '@material-ui/core'

{
  gM
  lang_is_zh
} = require '../../util'
PaperM = require '../../ui/paper_m'


EnableAll = cC {
  displayName: 'TabList_EnableAll'
  propTypes: {
    classes: PropTypes.object.isRequired

    enable_all: PropTypes.bool

    on_set_enable_all: PropTypes.func.isRequired
  }

  _on_toggle_enable_all: ->
    @props.on_set_enable_all(! @props.enable_all)

  _render_desc_en: ->
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

  _render_desc_zh_CN: ->
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

  _render_desc: ->
    if lang_is_zh()
      @_render_desc_zh_CN()
    else
      @_render_desc_en()

  render: ->
    (
      <PaperM class_name={ @props.classes.paper_enable_all }>
        <div className={ @props.classes.enable_all_title }>
          <Typography variant="headline" component="h3">
            { gM 'pot_enable_all' }
          </Typography>
          <Switch checked={ @props.enable_all } onChange={ @_on_toggle_enable_all } color="primary" />
        </div>
        { @_render_desc() }
      </PaperM>
    )
}

module.exports = EnableAll
