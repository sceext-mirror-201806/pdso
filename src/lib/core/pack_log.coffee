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

err_snapshot_end_error = (tab_id, e) ->
  # TODO

info_snapshot_start = (tab_id) ->
  _log "[ #{tab_id} ] INFO: snapshot start"

info_inject_contents = (tab_id) ->
  _log "[ #{tab_id} ] INFO: inject content script"


ok_snapshot_end = (tab_id) ->
  # TODO

module.exports = {
  err_tab_not_enable
  err_no_g_list
  err_no_rc
  err_snapshot_end_error

  info_snapshot_start
  info_inject_contents

  ok_snapshot_end
}
