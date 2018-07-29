# popup.coffee, pdso/src/


# FIXME
window.onload = ->
  document.getElementById('open_main_page').onclick = ->
    browser.tabs.create {
      url: '/page/options.html'
    }
    window.close()


# TODO
console.log "FIXME: end of popup. "
