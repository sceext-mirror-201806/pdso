# state.coffee, pdso/src/page_options/redux/

init_state = {
  theme: 'light'  # [ 'light', 'dark' ]

  page_value: 0

  # global tab_list data (in background main)
  g: {
    enable: {}
    list: []
    enable_all: false
  }

}

module.exports = init_state
