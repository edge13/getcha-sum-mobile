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
      backgroundImage: "/Default.png"

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

    @submit = Ti.UI.createView
      top: "273dip"
      left: "85dip"
      right: 0

    @submit.addEventListener "click", @login
      
    @container.add @emailBack
    @container.add @email
    @container.add @passwordBack
    @container.add @password
    @container.add @submit

    @window.add @container

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

module.exports = new LoginView()