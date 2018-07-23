# util.coffee, pdso/src/lib/


# i18n.getMessage
gM = (messageName, substitutions) ->
  browser.i18n.getMessage messageName, substitutions


module.exports = {
  gM
}
