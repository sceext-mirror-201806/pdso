# pack_zip.coffee, pdso/src/lib/core/
{ Buffer } = require 'buffer'

sha256 = require 'fast-sha256'
JSZip = require 'jszip'

{
  P_VERSION
  FILENAME_MAX_LENGTH
  PACK
} = require '../config'
{
  json_clone
  last_update
} = require '../util'
log = require './pack_log'


# gen pdso_meta.json
_gen_meta = (raw) ->
  {
    tab  # tab_list meta data
    cache  # r_cache meta data
    c_meta  # content_script meta data
    missing  # missing resources
    checksum  # checksum of packed files
    zip_filename  # the final pack zip filename
    pack_rl  # r_id list of packed resources
  } = raw
  # pdso_meta.json
  o = {
    # program version
    pdso_version: P_VERSION
    # all meta data
    meta: {
      # meta data from tab_list
      tab: {
        #tab_id: -1  # NOTE: rename `id` to `tab_id`
        #incognito: false  # true if tab is incognito mode
        #
        #title: ''
        #url: ''
        #favicon_url: ''  # page icon
        #
        #loading_status: ''
        #navigation_status: ''
        # meta data from r_cache
        #rc: {
        #  # NOTE: clean `tab_id` here
        #  after_reset: false  # after page reset
        #  count: 0  # all res record count
        #}
      }
      # cache meta data from r_cache
      # NOTE: only include meta of  packed resources
      cache: {
        #'r_id': {  # the request id
        #  # NOTE: clean `r_id` here
        # NOTE clean `error: false` and `error_desc: null`
        #  error: false  # true if load error
        #  error_desc: ''  # error description
        # NOTE clean `res_start: true`
        #  res_start: false  # after onResponseStarted
        # NOTE clean `done: true`
        #  done: false  # true if response completed
        # NOTE clean `data_done: true`
        #  data_done: false  # stream_filter.onstop()
        #  url: []  # url list of this resource
        #  method: ''
        #  type: ''
        #  frame_id: 0
        #}
      }
      # meta data from content script
      c_meta: {
        #res: {  # resources to pack
        #  css: [
        #    #{
        #    #  name: ''
        #    #  raw_url: ''
        #    #  full_url: ''
        #    #}
        #  ]
        #  img: [
        #    #{
        #    #  name: ''
        #    #  raw_url: ''
        #    #  full_url: ''
        #    #}
        #  ]
        #}
        # count for clean
        #clean_count: {
        #  rm_script: 0
        #  # NOTE: [] to .length
        #  rm_on: {
        #    #'onclick': 0
        #  }
        #  # NOTE: [] to .length
        #  javascript_url: 0
        #
        #  res_css: 0
        #  res_img: 0
        #}
        # document charset
        #charset: ''
        #charset_raw: []
      }
      # missing resources (full_url not match in r_cache)
      missing: {
        # missing images
        img: [
          #{
          #  name: ''
          #  raw_url: ''
          #  full_url: ''
          #}
        ]
        # image filesize == 0
        img_empty: [
          #{
          #  name: ''
          #  raw_url: ''
          #  full_url: ''
          #}
        ]
        # missing css
        css: [
          #{
          #  name: ''
          #  raw_url: ''
          #  full_url: ''
          #}
        ]
      }
    }
    # checksum of packed files
    checksum: {
      #'filename': {
      #  size: 0  # binary size in Byte
      #  sha256: 'hex'  # sha256 hash
      #}
    }
    # filenames in the final pack zip
    pack: {
      meta: PACK.META
      meta_hash: PACK.META_HASH
      index: PACK.INDEX
      zip: ''
    }

    # the last update time
    _last_update: ''
  }
  # set data, and clean meta
  o.meta.tab = tab
  # rename `meta.tab.id` -> `meta.tab.tab_id`
  o.meta.tab.tab_id = o.meta.tab.id
  Reflect.deleteProperty o.meta.tab, 'id'
  # remove `meta.tab.rc.tab_id`
  Reflect.deleteProperty o.meta.tab.rc, 'tab_id'

  for r_id in pack_rl
    o.meta.cache[r_id] = cache[r_id]

    one = o.meta.cache[r_id]
    # remove `cache[].r_id`
    Reflect.deleteProperty one, 'r_id'
    # clean some default values
    if ! one.error
      Reflect.deleteProperty one, 'error'
    if ! one.error_desc?
      Reflect.deleteProperty one, 'error_desc'
    if one.res_start
      Reflect.deleteProperty one, 'res_start'
    if one.done
      Reflect.deleteProperty one, 'done'
    if one.data_done
      Reflect.deleteProperty one, 'data_done'

  o.meta.c_meta = c_meta
  # clean: `meta.c_meta.clean_count.rm_on`, `[]` -> `.length`
  for i of o.meta.c_meta.clean_count.rm_on
    o.meta.c_meta.clean_count.rm_on[i] = o.meta.c_meta.clean_count.rm_on[i].length
  # clean: `meta.c_meta.clean_count.javascript_url`, `[]` -> `.length`
  o.meta.c_meta.clean_count.javascript_url = o.meta.c_meta.clean_count.javascript_url.length

  o.meta.missing = missing
  o.checksum = checksum
  o.pack.zip = zip_filename

  # set last update time
  o._last_update = last_update()
  o

# concat binary data in cache_data
_concat_data = (raw) ->
  o = []
  for i in raw
    o.push Buffer.from(i)
  Buffer.concat o

# pack one file in the zip, and hash it
_pack_and_hash = (d, filename, data) ->
  # data is a Buffer, d is zip.folder
  d.file filename, data
  b = Buffer.from sha256(data)
  {
    size: data.length
    sha256: b.toString 'hex'
  }

_zip_compress = (zip, comment) ->  # async
  await zip.generateAsync {
    type: 'blob'
    compression: 'DEFLATE'
    comment
  }

# clean title for filename (replace bad chars)
_clean_filename = (raw) ->
  bad_chars = '/\\|><:?*" -'
  to = '_'
  o = ''
  for c in raw
    if bad_chars.indexOf(c) != -1
      o += to
    else
      o += c
  # check for too long title
  if o.length > FILENAME_MAX_LENGTH
    console.log "WARNING: title ( #{o.length} ) too long !\n#{o}"
  o

# eg: `20180729_204002`
_gen_time_str = ->
  _zfill = (r) ->
    while r.length < 2
      r = '0' + r
    r
  d = new Date()
  year = "#{d.getFullYear()}"
  month = _zfill "#{d.getMonth() + 1}"
  day = _zfill "#{d.getDate()}"
  time = d.toTimeString().split(' ')[0].split(':').join('')
  "#{year}#{month}#{day}_#{time}"

_gen_zip_dir = (raw) ->
  "#{PACK.ZIP[0]}#{raw}#{PACK.ZIP[1]}#{_gen_time_str()}"

_gen_zip_filename = (zip_dir) ->
  # just add `.zip` suffix
  "#{zip_dir}#{PACK.ZIP[2]}"

pack_zip = (raw_data) ->
  {
    tab_id
    tab_list  # meta data from tab_list
    cache  # cache meta data from r_cache
    c_meta  # c_meta from content script

    html  # the final html string
    cache_data  # data cache from r_cache
    ic  # image cache from snapshot_core
  } = raw_data

  # gen filename
  clean_title = _clean_filename tab_list.title
  zip_dir = _gen_zip_dir clean_title
  zip_filename = _gen_zip_filename zip_dir

  missing = {
    img: []
    img_empty: []
    css: []
  }
  checksum = {}
  pack_rl = []

  # cache index: full_url to r_id
  ui = {
    #'full_url': r_id
  }
  for r_id of cache
    for i in cache[r_id].url
      # check r_id conflict
      old = ui[i]
      if old?
        console.log "WARNING: pack_zip: r_id conflict [ #{r_id}, #{old} ]\n#{i}"
        # use bigger r_id
        if r_id > old
          ui[i] = r_id
      else
        ui[i] = r_id

  # JSZip init
  zip = new JSZip()
  d = zip.folder zip_dir

  # pack index.html
  log.d_pack_index tab_id

  index_data = Buffer.from html, 'utf-8'
  c = _pack_and_hash d, PACK.INDEX, index_data
  checksum[PACK.INDEX] = c

  # pack css
  log.d_pack_css tab_id

  for i in c_meta.res.css
    # get r_id from full_url
    r_id = ui[i.full_url]
    # check missing
    if ! r_id?
      missing.css.push i
      continue
    # got it, pack
    data = _concat_data cache_data[r_id]
    c = _pack_and_hash d, i.name, data
    checksum[i.name] = c
    pack_rl.push r_id

  # pack image
  log.d_pack_img tab_id

  for i in c_meta.res.img
    r_id = ui[i.full_url]
    # check missing
    if ! r_id?
      missing.img.push i
      continue
    # check empty data
    raw_data = cache_data[r_id]
    if raw_data.length < 1
      # check ic
      data = ic[r_id]
      if ! data?
        missing.img_empty.push i
        # add cache meta for this image
        pack_rl.push r_id
        continue
    else
      data = _concat_data raw_data
    c = _pack_and_hash d, i.name, data
    checksum[i.name] = c
    pack_rl.push r_id

  # warn missing
  log.warn_missing_res tab_id, missing

  # pack meta
  log.d_pack_meta tab_id

  meta = _gen_meta {  # clone to protect meta data
    tab: json_clone tab_list
    cache: json_clone cache
    c_meta: json_clone c_meta

    missing
    checksum
    zip_filename
    pack_rl
  }
  # pdso_meta.json
  meta_text = JSON.stringify meta
  meta_data = Buffer.from meta_text, 'utf-8'
  meta_hash = _pack_and_hash d, PACK.META, meta_data

  console.log "DEBUG: sha256(meta) = #{meta_hash.sha256}"
  # pdso_meta.json.sha256.txt
  _pack_and_hash d, PACK.META_HASH, Buffer.from(meta_hash.sha256 + '\n')

  # compress zip
  log.d_pack_compress tab_id

  blob = await _zip_compress zip, zip_filename
  # return
  {
    filename: zip_filename
    blob  # zip data to download
  }

module.exports = pack_zip  # async
