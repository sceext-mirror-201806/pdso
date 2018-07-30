# config.coffee, pdso/src/lib/

P_VERSION = 'pdso version 0.1.0-a4 test20180730 1604'

# max length limit of pack zip filename
FILENAME_MAX_LENGTH = 127

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

  # for tab favicon load fail
  ADD_FAVICON_BLACKLIST: 'add_favicon_blacklist'

  # take a snapshot of one tab
  SNAPSHOT_ONE_TAB: 'snapshot_one_tab'

  # end of snapshot one tab
  SNAPSHOT_ONE_END: 'snapshot_one_end'

  # background log
  BG_LOG: 'bg_log'

  # event send from content script
  CONTENT: 'content'

  # events send to content script
  C_SNAPSHOT: 'c_snapshot'  # start of one snapshot
  C_FETCH_IMGS: 'c_fetch_imgs'  # request to fetch image binary data from cache
}

CONTENT_EVENT = {
  # end of the DOM snapshot
  SNAPSHOT_DONE: 'snapshot_done'

  # got one image binary data
  GOT_IMG: 'got_img'

  # end of fetch images
  FETCH_IMG_DONE: 'fetch_img_done'

  # error of content script
  ERROR: 'error'
}

# content scripts url
CONTENTS = {
  lib: '/js/content_lib.js'
  main: '/js/contents.js'
}

# filename for pack_zip
PACK = {
  META: 'pdso_meta.json'
  # sha256 hash checksum for meta json
  META_HASH: 'pdso_meta.json.sha256.txt'
  # main html file (the document)
  INDEX: 'index.html'
  # the final pack zip filename
  ZIP: [
    'pdso-'
    # clean title
    '-'
    # time to seconds, eg: `20180729_204002`
    '.zip'
  ]
}

module.exports = {
  P_VERSION

  FILENAME_MAX_LENGTH

  UI_THEME_LIGHT
  UI_THEME_DARK

  LCK_UI_THEME
  LCK_PDSO_TAB_LIST_ENABLE_ALL

  EVENT
  CONTENT_EVENT
  CONTENTS

  PACK
}
