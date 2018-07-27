# config.coffee, pdso/src/lib/

P_VERSION = 'pdso version 0.1.0-a1 test20180727 1724'

# const
UI_THEME_LIGHT = 'light'
UI_THEME_DARK = 'dark'

# lck: local config key, save config value in local storage
LCK_UI_THEME = 'ui.theme'
# core config: enable for all tabs
LCK_PDSO_TAB_LIST_ENABLE_ALL = 'pdso.tab_list.enable_all'

# events send/recv
# {
#   type: 'EVENT_TYPE'
#   error: false
#   payload: any
# }
EVENT = {
  # background main send tab_list data (update)
  TAB_LIST: 'tab_list'
  # TODO add update one tab for performance ?  (not update the whole list every time)

  # fetch tab_list data from background main
  FETCH_TAB_LIST: 'fetch_tab_list'

  # enable/disable one tab in background main
  SET_TAB_ENABLE: 'set_tab_enable'

  # take a snapshot of one tab
  SNAPSHOT_ONE_TAB: 'snapshot_one_tab'

  # end of snapshot one tab
  SNAPSHOT_ONE_END: 'snapshot_one_end'

  # background log
  BG_LOG: 'bg_log'

  # TODO
}

# content scripts url
CONTENTS = {
  lib: '/js/content_lib.js'
  load: '/js/content_load_img.js'
  snapshot: '/js/contents.js'
}

module.exports = {
  P_VERSION

  UI_THEME_LIGHT
  UI_THEME_DARK

  LCK_UI_THEME
  LCK_PDSO_TAB_LIST_ENABLE_ALL

  EVENT
  CONTENTS

}
