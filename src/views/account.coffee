api = require "api"
connectView = require "connect"
ProgoView = require "ProgoView"

class AccountView extends ProgoView
  layout: ->  

    @dwolla = Ti.UI.createButton
      width: "70%"
      height: "30dip"
      title: "Connect to Dwolla"

    @twitter = Ti.UI.createButton
      width: "70%"
      height: "30dip"
      title: "Connect to Twitter"

    @dwolla.addEventListener "click", (event) =>
      connectView.show
        url: "https://www.dwolla.com/oauth/v2/authenticate?client_id=" + @dwollaId + "&response_type=code&redirect_uri=" + api.host + "callbacks/dwolla/" + api.token + "&scope=Send|Transactions|Balance|Request|AccountInfoFull"

    @twitter.addEventListener "click", (event) =>
      connectView.show
        url: "https://api.singly.com/oauth/authenticate?client_id=" + @singlyId + "&redirect_uri=" + api.host + "callbacks/singly/" + api.token + "&service=twitter"

    @view.add @dwolla
    @view.add @twitter


module.exports = new AccountView()