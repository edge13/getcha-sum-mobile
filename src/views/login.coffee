class LoginView
  constructor: ->
    @window = Ti.UI.createWindow
      width: "100%"
      height: "100%"

    logo = Ti.UI.createLabel
      top: "30dip"
      left: "30dip"
      text: "POGO"

    @window.add logo

  show: ->
    do @window.open

module.exports = new LoginView()