AccountView = require "AccountView"
OffersListView = require "OffersListView"
MyOffersView = require "MyOffersView"
Pusher = require "Pusher"

class TabBar
  constructor: ->
    Pusher.onNewOffer = @showNotification

    @views = new Array()
    @selectedIndex = 1
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
        y: "50%"

    @leftButton.index = 0

    @rightButton = Ti.UI.createImageView
      image: "navBar/account-icon.png"
      hires: true
      center: 
        x: "80%"
        y: "50%"
    @rightButton.index = 2

    @middleButton = Ti.UI.createImageView
      image: "navBar/browse-icon.png"
      hires: true
      center: 
        x: "50%"
        y: "50%"

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
      color: "white"
      font:
        fontFamily: "Arvil"
        fontSize: "12sp"
      center:
        x: "20%"
      bottom: "1dp"

    @middleLabel = Ti.UI.createLabel
      text: "Browse Offers"
      color: "white"
      font:
        fontFamily: "Arvil"
        fontSize: "12sp"
      center:
        x: "50%"
      bottom: "1dp"

    @rightLabel = Ti.UI.createLabel
      text: "My Account"
      color: "white"
      font:
        fontFamily: "Arvil"
        fontSize: "12sp"
      center:
        x: "80%"
      bottom: "1dp"

    @tabBar.add @leftLabel
    @tabBar.add @middleLabel
    @tabBar.add @rightLabel

    @window.add @tabBar

  showNotification: (offer) =>
    Ti.API.info "showing notification"
    notificationView = Ti.UI.createView
      width: "80%"
      height: "40dp"
      top: "-40dp"
      backgroundImage: "notification.png"

    label = Ti.UI.createLabel
      text: "New Offer! Want to check it out?"
      font:
        fontFamily: "Arvil"
        fontSize: "14sp"
      color: "white"

    notificationView.add label

    notificationView.addEventListener "click", =>
      Ti.API.info "clicked notification"
      @show 1
      @views[@selectedIndex].showOfferDetail offer

    @views[@selectedIndex].window.add notificationView

    fadeOutAnimation = do Ti.UI.createAnimation
    fadeOutAnimation.duration = 500
    fadeOutAnimation.opacity = 0
    fadeOutAnimation.addEventListener "complete", =>
      @views[@selectedIndex].window.remove notificationView

    dropDownAnimation = do Ti.UI.createAnimation
    dropDownAnimation.duration = 500
    dropDownAnimation.top = 0
    dropDownAnimation.addEventListener "complete", =>
      setTimeout =>
        notificationView.animate fadeOutAnimation
      , 4000

    notificationView.animate dropDownAnimation
      


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
