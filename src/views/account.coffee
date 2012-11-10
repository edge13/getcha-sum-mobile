api = require "api"
connectView = require "connect"

class AccountView
  constructor: ->
    @window = Ti.UI.createWindow
      width: "100%"
      height: "100%"
      backgroundColor: "#ffffff"

    @dwolla = Ti.UI.createButton
      top: "20dip"
      width: "70%"
      height: "30dip"
      title: "Connect to Dwolla"

    @twitter = Ti.UI.createButton
      top: "50dip"
      width: "70%"
      height: "30dip"
      title: "Connect to Twitter"

    @dwolla.addEventListener "click", (event) ->
      connectView.show
        url: "https://www.dwolla.com/oauth/v2/authenticate?client_id=ApS2lLgIfKNXE4BbkuMS3rSs40XyEXvFqlc72nqJ9kTm7Tmrm6&response_type=code&redirect_uri=" + api.host + "callbacks/dwolla/" + api.token + "&scope=Send|Transactions|Balance|Request|AccountInfoFull"

    @twitter.addEventListener "click", (event) ->
     

    @window.add @dwolla

  show: ->
    do @window.open


module.exports = new AccountView()