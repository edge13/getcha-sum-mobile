api = require "api"
TabBar = require "TabBar"
Global = require "Global"

class LoginView
  constructor: ->
    @window = Ti.UI.createWindow
      width: "100%"
      height: "100%"

    @container = Ti.UI.createScrollView
      width: "100%"
      height: "100%"
      contentWidth: "100%"
      contentHeight: "100%"

    @canvas = Ti.UI.createView
      width: "100%"
      height: "100%"
      backgroundImage: "/background.png"

    @container.add @canvas

    @emailBack = Ti.UI.createView
      backgroundImage: "/text-createoffername.png"
      top: "195dip"
      left: "15dip"
      right: "15dip"
      height: "30dip"
    
    @email = Ti.UI.createTextField
      top: "202dip"
      left: "20dip"
      right: "20dip"
      hintText: "EMAIL ADDRESS"
      font:
        fontFamily: "Avenir LT Std"
        fontSize: "18sp"
      color: "#ffffff"

    @email.addEventListener "return", (event) =>
      do @password.focus

    @passwordBack = Ti.UI.createView
      backgroundImage: "/text-createoffername.png"
      top: "235dip"
      left: "15dip"
      right: "15dip"
      height: "30dip"

    @password = Ti.UI.createTextField
      top: "242dip"
      left: "20dip"
      right: "20dip"
      hintText: "PASSWORD"
      font:
        fontFamily: "Avenir LT Std"
        fontSize: "18sp"
      color: "#ffffff"
      passwordMask: true

    @password.addEventListener "return", @login

    @mustache = Ti.UI.createImageView
      image: "/mustache.png"
      left: "120dip"
      top: "275dip"

    @logo = Ti.UI.createImageView
      image: "/logo.png"
      right: "20dip"
      top: "275dip"

    @logo.addEventListener "click", @login
      
    @container.add @emailBack
    @container.add @email
    @container.add @passwordBack
    @container.add @password
    @container.add @mustache
    @container.add @logo
    @window.add @container

    @money = new Array()
    setInterval @makeMoney, 30

  login: (event) =>
    Ti.API.info "Authenticating"
    api.login
      data:
        email: @email.value
        password: @password.value
      success: (response) =>
        api.token = response.token
        api.getMe
          success: (me) =>
            Global.me = me
            do TabBar.open
            do @window.close

  show: ->
    do @window.open

  makeMoney: =>
    rand = Math.random() * 100
    if rand > 95
      do @makeDollar

    do @updateDollars

  makeDollar: =>
    dollar = {}
    dollar.index = Math.floor(Math.random() * 13) + 1
    dollar.y = -10.0
    dollar.x = 10 + Math.floor(Math.random() * 300)
    dollar.yv = 5.5 + Math.random() * 1.0

    dollar.image = Ti.UI.createImageView
      image: "/money/dollar" + dollar.index + ".png"
      left: dollar.x
      top: dollar.y
    @canvas.add dollar.image
    @money.push dollar

  updateDollars: ->
    for dollar in @money
      if dollar.done
        continue
      dollar.y += dollar.yv
      dollar.image.top = dollar.y
      dollar.yv *= 0.993
      if dollar.y > Titanium.Platform.displayCaps.platformHeight
        @canvas.remove dollar.image
        dollar.image = undefined
        dollar.done = true



module.exports = new LoginView()