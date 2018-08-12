# pack_log.coffee, pdso/src/lib/core/

{
  m_send
  gM
} = require '../util'
m_ac = require '../m_action'


_log = (text) ->
  m_send m_ac.bg_log(text)

err_tab_not_enable = (tab_id) ->
  # TODO

err_no_g_list = (tab_id) ->
  # TODO

err_no_rc = (tab_id) ->
  # TODO

err_snapshot_end = (tab_id, e) ->
  _log "( #{tab_id} ) #{gM 'pl_err_snapshot_end'} #{e}\n#{e.stack}"

info_snapshot_start = (tab_id) ->
  _log "( #{tab_id} ) #{gM 'pl_info_snapshot_start'}"

d_inject_contents = (tab_id) ->
  _log "( #{tab_id} ) #{gM 'pl_d_inject_contents'}"

info_snapshot_dom_and_clean = (tab_id) ->
  _log "( #{tab_id} ) #{gM 'pl_info_snapshot_dom_and_clean'}"

d_fetch_imgs = (tab_id, n) ->
  if n > 0
    _log "( #{tab_id} ) #{gM 'pl_d_fetch_imgs', "#{n}"}"

info_pack_start = (tab_id) ->
  _log "( #{tab_id} ) #{gM 'pl_info_pack_start'}"

d_pack_index = (tab_id) ->
  _log "( #{tab_id} ) #{gM 'pl_d_pack_index'}"

d_pack_css = (tab_id, n) ->
  if n > 0
    _log "( #{tab_id} ) #{gM 'pl_d_pack_css', "#{n}"}"

d_pack_img = (tab_id, n) ->
  if n > 0
    _log "( #{tab_id} ) #{gM 'pl_d_pack_img', "#{n}"}"

d_pack_meta = (tab_id) ->
  _log "( #{tab_id} ) #{gM 'pl_d_pack_meta'}"

d_pack_compress = (tab_id, compress_level) ->
  _log "( #{tab_id} ) #{gM 'pl_d_pack_compress', compress_level}"

warn_missing_res = (tab_id, missing) ->
  count = 0
  for i of missing
    count += missing[i].length
  if count > 0
    _log "( #{tab_id} ) #{gM 'pl_warn_missing_res', "#{count}"}\n#{JSON.stringify missing}"

ok_snapshot_end = (tab_id, filename) ->
  _log "( #{tab_id} ) #{gM 'pl_ok_snapshot_end', filename}"

module.exports = {
  err_tab_not_enable
  err_no_g_list
  err_no_rc

  err_snapshot_end

  info_snapshot_start
  d_inject_contents
  info_snapshot_dom_and_clean
  d_fetch_imgs

  info_pack_start
  d_pack_index
  d_pack_css
  d_pack_img
  d_pack_meta
  d_pack_compress
  warn_missing_res

  ok_snapshot_end
}
