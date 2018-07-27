# util.coffee, pdso/src/lib/


# i18n.getMessage
gM = (messageName, substitutions) ->
  browser.i18n.getMessage messageName, substitutions

# check current UI language is zh_CN
lang_is_zh = ->
  lang = browser.i18n.getUILanguage()
  if (lang is 'zh-CN') or (lang is 'zh_CN')
    true
  else if lang.startsWith('zh-') or lang.startsWith('zh_')
    true
  else
    false


# event (message) send/recv

m_send = (data) ->
  # ignore all error
  try
    await browser.runtime.sendMessage data
  catch e
    console.log "ERROR: util.m_send  #{e}  #{e.stack}\n#{JSON.stringify data}"

# send message to content_script
m_send_content = (tab_id, data, options) ->
  browser.tabs.sendMessage tab_id, data, options

# send onMessage event listener
# callback(message, sender, sendResponse)
m_set_on = (callback) ->
  browser.runtime.onMessage.addListener callback

m_remove_listener = (callback) ->
  browser.runtime.onMessage.removeListener callback


module.exports = {
  gM
  lang_is_zh

  m_send  # async
  m_send_content  # async
  m_set_on
  m_remove_listener

}
