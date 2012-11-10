class TabBar
  constructor: ->
    @views = new Array()
    @selectedIndex = 0

    @window = Ti.UI.createWindow
      width: "100%"
      height: "100%"
      backgroundColor: '#ffffff'

    @tabBar = Ti.UI.createView
      height: "10%"
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


    listener = (e) =>
      @show e.source.index

    @leftButton.addEventListener "click", listener
    @rightButton.addEventListener "click", listener
    @middleButton.addEventListener "click", listener

    @window.add @tabBar

  add: (view) ->
    @views.push view

    if @views.length is 1
       @window.add view

  show: (index) ->
    return if index is @selectedIndex

    @window.add @views[index]
    @window.remove @views[@selectedIndex]
    @selectedIndex = index
  open: ->
    do @window.open

  close: ->
    do @window.close

module.exports = new TabBar()
