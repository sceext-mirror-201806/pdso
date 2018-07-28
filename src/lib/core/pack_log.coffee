# pack_log.coffee, pdso/src/lib/core/

{
  m_send
} = require '../util'
m_ac = require '../m_action'


_log = (text) ->
  m_send m_ac.bg_log(text)

# TODO i18n

err_tab_not_enable = (tab_id) ->
  # TODO

err_no_g_list = (tab_id) ->
  # TODO

err_no_rc = (tab_id) ->
  # TODO

err_snapshot_end = (tab_id, e) ->
  _log "( #{tab_id} ) ERROR: #{e}  #{e.stack}"

info_snapshot_start = (tab_id) ->
  _log "( #{tab_id} ) INFO: snapshot start"

d_inject_contents = (tab_id) ->
  _log "( #{tab_id} ) DEBUG: inject content script"

info_snapshot_dom_and_clean = (tab_id) ->
  _log "( #{tab_id} ) INFO: take a snapshot of the DOM and clean it"

d_fetch_imgs = (tab_id, n) ->
  if n > 0
    _log "( #{tab_id} ) DEBUG: fetch #{n} images from cache"

info_pack_start = (tab_id) ->
  _log "( #{tab_id} ) INFO: start pack"

warn_missing_res = (tab_id, list) ->
  # TODO

ok_snapshot_end = (tab_id, filename) ->
  _log "( #{tab_id} ) OK: save snapshot as #{filename}"

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
  warn_missing_res

  ok_snapshot_end
}
