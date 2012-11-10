class AccountView
  constructor: ->
    @window = Ti.UI.createWindow
      width: "100%"
      height: "100%"
      backgroundColor: "#ffffff"

    @dwolla = Ti.UI.createButton
      width: "70%"
      height: "30dip"
      title: "Connect to Dwolla"

    @window.add @dwolla

  show: ->
    do @window.open


module.exports = new AccountView()