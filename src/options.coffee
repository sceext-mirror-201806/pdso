# options.coffee, pdso/src/
React = require 'react'
ReactDOM = require 'react-dom'

{
  createStore
  applyMiddleware
} = require 'redux'
{ default: thunk } = require 'redux-thunk'

{ Provider } = require 'react-redux'

reducer = require './lib/page_options/redux/reducer'
App = require './lib/page_options/app'


# redux store
store = createStore reducer, applyMiddleware(thunk)

A = ->
  (
    <Provider store={ store }>
      <App />
    </Provider>
  )

_mount_root = ->
  console.log "DEBUG: page_options mount root"

  ReactDOM.render (<A />), document.querySelector('#react_root')

# mount root after page load
window.addEventListener 'load', _mount_root

console.log "DEBUG: end of options.js"
