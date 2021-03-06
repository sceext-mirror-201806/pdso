<!-- README.md, pdso/ -->

(`zh_CN`, [English README](doc/en/README.md))

# pdso: 页面离线快照
<https://bitbucket.org/eisf/pdso/>

(`pdso`: Page DOM Snapshot for Offline,
 用于桌面和 Android 版 Firefox 的浏览器扩展. )

对页面的 DOM 做一个静态快照, (修改并) 保存起来, 以供离线查看,
 包含 CSS 样式和图片, 不含脚本程序代码 (JavaScript).


## 特色

+ 获取动态页面的静态快照, 并将其保存为 HTML, 而不是图片.

+ 保留所有页面样式和图片, 保存的页面就和你当时看到的一样.

+ 保存之前移除页面中的所有脚本程序代码 (JavaScript).

+ 将所有文件 (HTML 文件, 图片, CSS 文件) 打包保存在一个 zip 压缩包中.


## 安装和使用

作为 Firefox 浏览器扩展安装: <https://addons.mozilla.org/zh-CN/addon/pdso/>

![tab_list](doc/p/zh_CN-android-tab_list.png)

1. 点击右侧的开关来启用想要快照的页面.

2. 可能需要刷新以重置相应页面.

3. 点击下载按钮开始快照 !

![tab_list](doc/p/zh_CN-android-tab_log.png)

**建议**: 请使用最新版 Firefox 浏览器查看保存的快照, 以便获得最佳显示效果.


## 工作原理

本扩展会在后台监视浏览器的标签页, 使用 Firefox 扩展的
 [tabs](https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/API/tabs)
 和
 [webNavigation](https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/API/webNavigation)
 API.

当某个标签页启用后, 本程序会记录其页面加载的所有资源数据, 使用
 [webRequest](https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/API/webRequest)
 和
 [StreamFilter](https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/API/webRequest/StreamFilter)
 API.

快照时, 向页面注入
 [content script](https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/API/contentScripts),
 并对 DOM 进行快照
 ([`document.cloneNode(true)`](https://developer.mozilla.org/en-US/docs/Web/API/Node/cloneNode)).
然后进行清理和修改, 比如移除 `<script>`,
 修改 `<link rel="stylesheet" href="" />` 和 `<img src="" />`.

最后,
 [将 DOM 转为 HTML](https://developer.mozilla.org/en-US/docs/Web/API/XMLSerializer)
 并打包 `.css` 文件, 图片, 等.
使用 [JSZip](https://stuk.github.io/jszip/) 压缩并
 [保存](https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/API/downloads)
 为 zip 文件.


## 已知问题

+ 目前本程序无法打包页面的所有资源, 并不能处理所有情况.
  所以快照可能看起来与原始页面有一些区别.


## 路线图

+ *(TODO)* 支持由 CSS 加载的资源, 比如背景图片, 网络字体, 等.  (解析 CSS)

+ *(TODO)* 支持 `<frame>` 和 `<iframe>`.

+ *(TODO)* 捕获 `<canvas>` 并将其保存为图片.

+ *(TODO)* 保存其它资源, 比如视频和音频.


## 更新日志

[CHANGELOG.md](doc/zh_CN/CHANGELOG.md)


## 从源代码编译

1. 安装 [`node.js`](https://nodejs.org/en/) 和
  [`yarn`](https://yarnpkg.com/en/).

2. 在项目根目录运行下列命令:

  ```
  > yarn install

  > yarn run build-release

  ```


## LICENSE

```
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
```
