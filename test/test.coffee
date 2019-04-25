{ get } = require 'http'
{ openBrowser, goto, closeBrowser, loadPlugin } = require 'taiko'
{ assert } = require 'chai'
{ createElement } = require 'react'
{ ID, clientHandler, react } = require 'taiko-react'

URL = "http://localhost:3000"

waitForServer = () ->
  await new Promise((resolve) -> setTimeout resolve, 1000)
  try
    await new Promise((resolve, reject) ->
      get(URL, resolve).on('error', reject))
  catch
    await waitForServer()

beforeHook = () ->
  this.timeout 30 * 1000
  try
    await loadPlugin ID, clientHandler
    await openBrowser()
    await waitForServer()
    await goto URL
  catch error
    console.error error

before beforeHook

describe 'Functional tests', () ->
  it 'successfully finds the App', () ->
    app = await react 'App'
    assert.isTrue app.exists()
  
  it 'does not find AppABC', ->
    app = await react 'AppABC'
    assert.isFalse app.exists()
  
  it 'successfully finds the <App />', () ->
    app = await react createElement 'App'
    assert.isTrue app.exists()
  
  it 'does not find <AppABC />', ->
    app = await react createElement 'AppABC'
    assert.isFalse app.exists()

afterHook = () ->
  await closeBrowser()

after afterHook
