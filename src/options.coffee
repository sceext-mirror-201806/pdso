# options.coffee, pdso/src/
React = require 'react'
ReactDOM = require 'react-dom'

{
  createStore
  applyMiddleware
} = require 'redux'
{ default: thunk } = require 'redux-thunk'
# TODO devtools for redux ?

{ Provider } = require 'react-redux'

reducer = require './page_options/redux/reducer'
PageMain = require './page_options/page_main'


# redux store
store = createStore reducer, applyMiddleware(thunk)
# TODO

App = ->
  (
    <Provider store={ store }>
      <PageMain />
    </Provider>
  )

_mount_root = ->
  console.log "DEBUG: page_options mount root"

  ReactDOM.render (<App />), document.querySelector('#react_root')

# mount root after page load
window.addEventListener 'load', _mount_root

console.log "DEBUG: end of options.js "
