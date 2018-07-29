# clean_dom.coffee, pdso/src/lib/core/

jquery = require 'jquery'

{
  is_data_url
} = require '../util'

# TODO rename resources ?

# TODO support <link > web fonts ?
# TODO parse all CSS ?  and check background images, etc.


_visit_node = (root, f) ->
  f(root)
  for i in Array.from(root.children)
    _visit_node i, f

_get_img_ext = (img) ->
  # TODO improve this method
  p = img.src.split('?')[0].split('/')
  p = p[p.length - 1].split('.')
  ext = p[p.length - 1].trim()
  if ext.length > 0
    ".#{ext}"
  else
    '.unknow.png'

clean_dom = (root) ->
  o = {
    html: null  # the html string
    c_meta: {  # meta data by content script
      res: {  # resources should be packed
        css: [  # <link rel="stylesheet" type="text/css" href=""  />
          #{
          #  name: 's1.css'
          #  raw_url: ''  # $().attr('href')
          #  full_url: ''  # $().prop('href')
          #}
        ]
        img: [  # <img src=""  />
          #{
          #  name: 'p1.png'
          #  raw_url: ''  # $().attr('src')
          #  full_url: ''  # $().prop('src')
          #}
        ]
        # TODO more type of resources ?
      }
      # count for clean process
      clean_count: {
        rm_script: 0  # number of <script> removed
        rm_on: {  # number of event listeners removed
          #'onclick': []
        }
        javascript_url: []  # for warning about `javascript:` URLs

        res_css: 0  # number of <link rel="stylesheet"  />
        res_img: 0  # number of <img src=""  />
      }
      # document charset
      charset: root.charset.toLowerCase()
      charset_raw: []  # raw charset element
    }
  }
  $ = jquery

  # remove all <script>
  _remove_script = (node) ->
    if node.nodeName.toLowerCase() is 'script'
      node.remove()
      o.c_meta.clean_count.rm_script += 1
  _visit_node root, _remove_script

  # remove all `on*` event listeners
  _remove_on = (node) ->
    if node.attributes?
      for a in Array.from(node.attributes)
        if a.name.toLowerCase().startsWith('on')
          if ! o.c_meta.clean_count.rm_on[a.name]?
            o.c_meta.clean_count.rm_on[a.name] = []
          o.c_meta.clean_count.rm_on[a.name].push a.value
          node.removeAttribute(a.name)
  _visit_node root, _remove_on

  # warn about `javascript:` urls
  _warn_javascript_url = (node) ->
    switch node.nodeName.toLowerCase()
      when 'a'
        if node.href.trim().toLowerCase().startsWith('javascript:')
          o.c_meta.clean_count.javascript_url.push node.href
    # TODO check other elements, not only <a> ?
  _visit_node root, _warn_javascript_url

  # fix <meta charset="" > in <head>
  _remove_meta_charset = (node) ->
    _remove = ->
      o.c_meta.charset_raw.push node.outerHTML
      node.remove()

    if node.nodeName.toLowerCase() is 'meta'
      for a in Array.from(node.attributes)
        # <meta charset="utf-8" />
        if a.name.toLowerCase() is 'charset'
          _remove()
          return
        # <meta http-equiv="content-type" content="text/html; charset=utf-8" >
        else if a.name.toLowerCase() is 'http-equiv'
          if a.value.toLowerCase() is 'content-type'
            _remove()
            return
  _visit_node root, _remove_meta_charset
  # insert <meta charset="utf-8" /> in <head>
  meta = $('<meta charset="utf-8" />')[0]
  if root.head.children.length < 1
    root.head.appendChild(meta)
  else
    root.head.insertBefore(meta, root.head.children[0])

  # index to avoid duplicated imgs
  _img_full_url_i = {
    #'FULL_URL': 1  # index
  }
  # check all css and img
  _check_res = (node) ->
    switch node.nodeName.toLowerCase()
      # <link rel="stylesheet" type="text/css" href=""  />
      when 'link'
        if node.getAttribute('rel') != 'stylesheet'
          return

        raw_url = $(node).attr('href')
        full_url = $(node).prop('href')
        # ignore `data:` url
        if is_data_url full_url
          return

        # TODO check css duplicated ?
        # update count
        o.c_meta.clean_count.res_css += 1

        one = {
          name: "s#{o.c_meta.clean_count.res_css}.css"
          raw_url
          full_url
        }
        # modify href
        node.href = one.name

        o.c_meta.res.css.push one
      # <img src=""  />
      when 'img'
        raw_url = $(node).attr('src')
        full_url = $(node).prop('src')
        # ignore `data:` url
        if is_data_url full_url
          return
        # update count
        o.c_meta.clean_count.res_img += 1
        # check img duplicated
        i = _img_full_url_i[full_url]
        if i?
          one = o.c_meta.res.img[i]
          # check raw_url match
          if raw_url != one.raw_url
            console.log "WARNING: img.raw_url [ #{raw_url} ] != [ #{one.raw_url} ], full_url = #{full_url}"
          name = one.name  # re-use this image
        else
          one = {
            name: "p#{o.c_meta.clean_count.res_img}#{_get_img_ext node}"
            raw_url
            full_url
          }
          # set index
          _img_full_url_i[full_url] = o.c_meta.res.img.length

          o.c_meta.res.img.push one
        # modify src
        node.src = name
  _visit_node root, _check_res

  # gen the final html
  o.html = new XMLSerializer().serializeToString(root)
  o

module.exports = clean_dom
