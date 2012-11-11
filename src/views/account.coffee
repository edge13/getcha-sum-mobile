api = require "api"
connectView = require "connect"
ProgoView = require "ProgoView"
Global = require "Global"
UserUtil = require "UserUtil"

class AccountView extends ProgoView
  layout: ->

    @containerView = Ti.UI.createScrollView
      height: "100%"
      width: "100%"
      layout: "vertical"

    @emailLabel = Ti.UI.createLabel
      left: "10%"
      right: "10%"
      height: "50dp"
      top: 0

    @containerView.add @emailLabel

    @buttonsView = Ti.UI.createView
      height: "400dp"
      backgroundColor: 'purple'
      width: "100%"
      top: "25dp"


    @dwolla = Ti.UI.createButton
      top: "70dp"
      left: "30dp"
      width: "65dp"
      height: "65dp"
      title: "Dwolla"

    @twitter = Ti.UI.createButton
      top: "70dp"
      left: "110dp"
      width: "65dp"
      height: "65dp"
      title: "Twitter"

    @facebook = Ti.UI.createButton
      top: "70dp"
      left: "190dp"
      width: "65dp"
      height: "65dp"
      title: "FB"

    #access_token
    @facebook.addEventListener "click", (event) =>
      connect = new connectView
        url: api.buildSinglyUrlForService "facebook"
        close: @popModal
      @showModal connect.view

    @dwolla.addEventListener "click", (event) =>
      connect = new connectView
        url: "https://www.dwolla.com/oauth/v2/authenticate?client_id=" + @dwollaId + "&response_type=code&redirect_uri=" + api.host + "callbacks/dwolla/" + api.token + "&scope=Send|Transactions|Balance|Request|AccountInfoFull"
        close: =>
          @popModal
          @updateSeletions
        cancelUrl: "http://www.dwolla.com/"
        
      @showModal connect.view

    @twitter.addEventListener "click", (event) =>
      connect = new connectView
        url: api.buildSinglyUrlForService "twitter"
        close: =>
          @popModal
          @updateSeletions
      @showModal connect.view

    @buttonsView.add @facebook
    @buttonsView.add @dwolla
    @buttonsView.add @twitter
    @containerView.add @buttonsView

    @divider = Ti.UI.createView
      height: '20dp'
      backgroundColor: "blue"
      width: "100%"
      top: "5dp"
      bottom: "5dp"

    @containerView.add @divider

    @demoLabel = Ti.UI.createLabel
      text: "add your demographic information will help us provide you with more offers"
      width: "100%"
      height: "40dp"
      top: "10dp"

    @containerView.add @demoLabel


    @view.add @containerView


  updateSeletions: ->
    Ti.API.info Global.me

    @emailLabel.text =  "Account #{Global.me.email}"

    
    ###if Global.me.dwollaAccessToken?
      @dwolla.backgroundColor = "green"
    else
      @dwolla.backgroundColor = "red"

    if UserUtil.twitterAlias(Global.me)?
      @twitter.backgroundColor = "green"
    else
      @twitter.backgroundColor =  "red"###

  onShow: ->
    do @updateSeletions

module.exports = new AccountView()