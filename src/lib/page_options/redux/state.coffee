# state.coffee, pdso/src/lib/page_options/redux/

init_state = {
  theme: 'light'  # [ 'light', 'dark' ]

  page_value: 0

  # global tab_list data (in background main)
  g: {
    enable: {}
    list: {}  # sort list by tab_id
    enable_all: false
  }
  # disable one tab before snapshot end
  disable_tab: {
    #'TAB_ID': false  # true to disable
  }

  # logs to show
  log: [
    #{
    #  time: ''  # ISO time string
    #  text: ''  # log text to show
    #}
  ]

  # core config: pdso.jszip_level
  config: {
    pdso_jszip_level: 0
  }
}

module.exports = init_state
