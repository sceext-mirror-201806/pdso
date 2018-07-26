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

}

module.exports = init_state
