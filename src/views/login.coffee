class LoginView
  constructor: ->
    @window = Ti.UI.createWindow
      width: "100%"
      height: "100%"
      backgroundColor: "#ffffff"

    logo = Ti.UI.createLabel
      top: "30dip"
      left: "30dip"
      text: "POGO"

    @email = Ti.UI.createTextField
      top: "90dip"
      left: "60dip"
      hintText: "Email Address"
      width: "200dip"
      height: "40dip"
      borderWidth: "1dip"
      borderColor: "#000000"

    @password = Ti.UI.createTextField
      top: "140dip"
      left: "60dip"
      passwordMask: true
      hintText: "Password"
      width: "200dip"
      height: "40dip"
      borderWidth: "1dip"
      borderColor: "#000000"

    @submit = Ti.UI.createButton
      top: "190dip"
      left: "50dip"
      width: "200dip"
      title: "Submit"

    @submit.addEventListener "click", (event) ->
      Ti.API.info "Logging in"

    @window.add logo
    @window.add @email
    @window.add @password
    @window.add @submit

  show: ->
    do @window.open

module.exports = new LoginView()