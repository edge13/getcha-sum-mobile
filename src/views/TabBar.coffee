account = require "account"
offers = require "OffersList"
myoffers = require "myoffers"

class TabBar
  constructor: ->
    @views = new Array()
    @selectedIndex = 0

    @window = Ti.UI.createWindow
      width: "100%"
      height: "10%"
      backgroundColor: '#ffffff'
      bottom: 0

    @tabBar = Ti.UI.createView
      height: "100%"
      width: "100%"
      backgroundColor: "pink"
      bottom: 0
      layout: "horizontal"

    @leftButton = Ti.UI.createButton
      title: "1"
      height: "100%"
      width: "33%"
    @leftButton.index = 0

    @rightButton = Ti.UI.createButton
      title: "3"
      height: "100%"
      width: "33%"
    @rightButton.index = 2

    @middleButton = Ti.UI.createButton
      title: "2"
      height: "100%"
      width: "33%"
    @middleButton.index = 1

    @tabBar.add @leftButton
    @tabBar.add @middleButton
    @tabBar.add @rightButton

    @add account
    @add myoffers
    @add offers
    

    listener = (e) =>
      @show e.source.index

    @leftButton.addEventListener "click", listener
    @rightButton.addEventListener "click", listener
    @middleButton.addEventListener "click", listener

    @window.add @tabBar

  add: (progoView) ->
    @views.push progoView

  show: (index) ->
    return if index is @selectedIndex

    do @views[index].open
    do @views[@selectedIndex].close
    @selectedIndex = index

    do @views[@selectedIndex].onShow

  open: ->
    do @window.open
    do @views[@selectedIndex].open
    do @views[@selectedIndex].onShow

  close: ->
    do @window.close
    do @views[@selectedIndex].close

module.exports = new TabBar()
