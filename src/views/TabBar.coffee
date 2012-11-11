AccountView = require "AccountView"
OffersListView = require "OffersListView"
MyOffersView = require "MyOffersView"
Pusher = require "Pusher"

class TabBar
  constructor: ->
    @views = new Array()
    @selectedIndex = 0
    @buttons = new Array()

    @window = Ti.UI.createWindow
      width: "100%"
      bottom: 0
      backgroundImage: "navBar/navbar-bg.png"
      height: "12%"

    @tabBar = Ti.UI.createView
      height: "100%"
      width: "100%"
      backgroundColor: "transparent"
      bottom: 0
      #layout: "horizontal"

    @leftButton = Ti.UI.createImageView
      image: "navBar/myoffers-icon.png"
      hires: true
      center: 
        x: "20%"
        y: "55%"

    @leftButton.index = 0

    @rightButton = Ti.UI.createImageView
      image: "navBar/account-icon.png"
      hires: true
      center: 
        x: "80%"
        y: "55%"
    @rightButton.index = 2

    @middleButton = Ti.UI.createImageView
      image: "navBar/browse-icon.png"
      hires: true
      center: 
        x: "50%"
        y: "55%"

    @middleButton.index = 1

    @selectionView = Ti.UI.createImageView
      image: "navBar/navbar-bg-active.png"
      hires: true
    @selectionView.hide()

    @buttons.push @leftButton
    @buttons.push @middleButton
    @buttons.push @rightButton

    @tabBar.add @selectionView
    @tabBar.add @leftButton
    @tabBar.add @middleButton
    @tabBar.add @rightButton

    @add MyOffersView
    @add OffersListView
    @add AccountView

    listener = (e) =>
      @show e.source.index

    @leftButton.addEventListener "click", listener
    @rightButton.addEventListener "click", listener
    @middleButton.addEventListener "click", listener

    @leftLabel = Ti.UI.createLabel
      text: "My Offers"
      font:
        fontFamily: "Arvil"
        fontSize: "14sp"
      center:
        x: "20%"
      bottom: "5dp"

    @middleLabel = Ti.UI.createLabel
      text: "Offers"
      font:
        fontFamily: "Arvil"
        fontSize: "14sp"
      center:
        x: "50%"
      bottom: "5dp"

    @rightLabel = Ti.UI.createLabel
      text: "My Account"
      font:
        fontFamily: "Arvil"
        fontSize: "14sp"
      center:
        x: "80%"
      bottom: "5dp"

    @tabBar.add @leftLabel
    @tabBar.add @middleLabel
    @tabBar.add @rightLabel

    @window.add @tabBar

  add: (progoView) ->
    @views.push progoView

  show: (index) ->
    return if index is @selectedIndex

    do @views[index].open
    do @views[@selectedIndex].close
    @selectedIndex = index

    do @views[@selectedIndex].onShow
    do @window.close
    do @window.open

    @selectionView.center = @buttons[@selectedIndex].center
    @selectionView.show()

  open: ->
    do @views[@selectedIndex].open
    do @views[@selectedIndex].onShow
    do @window.open
    @selectionView.center = @buttons[@selectedIndex].center
    @selectionView.show()

  close: ->
    do @window.close
    do @views[@selectedIndex].close

module.exports = new TabBar()
