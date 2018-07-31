# popup.coffee, pdso/src/


# TODO
window.onload = ->
  document.getElementById('open_main_page').onclick = ->
    browser.tabs.create {
      url: '/page/options.html'
    }
    window.close()

console.log "DEBUG: end of popup.js"
