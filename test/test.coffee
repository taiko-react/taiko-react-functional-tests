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

describe 'Functional tests', ->
  describe '#exists', ->
    it 'successfully finds the App', ->
      app = await react 'App'
      assert.isTrue app.exists()
    
    it 'does not find AppABC', ->
      app = await react 'AppABC'
      assert.isFalse app.exists()
    
    it 'successfully finds the <App />', ->
      app = await react createElement 'App'
      assert.isTrue app.exists()
    
    it 'does not find <AppABC />', ->
      app = await react createElement 'AppABC'
      assert.isFalse app.exists()
  
  describe '#length', ->
    it 'finds two Logos', ->
      logo = await react 'Logo', { multiple: true }
      assert.equal logo.length(), 2

    it 'finds one App', ->
      app = await react 'App'
      assert.equal app.length(), 1
    
    it 'does not find Batman', ->
      batman = await react 'Batman'
      assert.equal batman.length(), 0
    
    it 'does not find multiple Narutos', ->
      narutos = await react 'Naruto', { multiple: true }
      assert.equal narutos.length(), 0

afterHook = () ->
  await closeBrowser()

after afterHook
