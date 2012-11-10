api = require "api"
connectView = require "connect"
ProgoView = require "ProgoView"

class AccountView extends ProgoView
  constructor: ->
    super
    @dwollaId = "ApS2lLgIfKNXE4BbkuMS3rSs40XyEXvFqlc72nqJ9kTm7Tmrm6"
    @singlyId = "54e441cddf0c4c2cf1bc54de317913df"

  layout: ->
    @view.layout = "vertical"
    
    @dwolla = Ti.UI.createButton
      width: "70%"
      height: "30dip"
      title: "Connect to Dwolla"

    @twitter = Ti.UI.createButton
      width: "70%"
      height: "30dip"
      title: "Connect to Twitter"

    @dwolla.addEventListener "click", (event) =>
      connect = new connectView
        url: "https://www.dwolla.com/oauth/v2/authenticate?client_id=" + @dwollaId + "&response_type=code&redirect_uri=" + api.host + "callbacks/dwolla/" + api.token + "&scope=Send|Transactions|Balance|Request|AccountInfoFull"
        close: @popModal
        cancelUrl: "http://www.dwolla.com/"
        
      @showModal connect.view

    @twitter.addEventListener "click", (event) =>
      connect = new connectView
        url: "https://api.singly.com/oauth/authenticate?client_id=" + @singlyId + "&redirect_uri=" + api.host + "callbacks/singly/" + api.token + "&service=twitter"
        close: @popModal
        cancelUrl: "https://api.twitter.com/oauth/authenticate"
      @showModal connect.view
      
    @view.add @dwolla
    @view.add @twitter

module.exports = new AccountView()