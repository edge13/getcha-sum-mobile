api = require "api"
ConnectView = require "ConnectView"
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
      backgroundColor: "transparent"
      width: "100%"
      top: "25dp"

    @dwolla = @buttonForService "dwolla", 0
    @twitter = @buttonForService "twitter", 1
    @facebook = @buttonForService "facebook", 2
    @linkedin = @buttonForService "linkedin", 3
    @tumblr = @buttonForService "tumblr", 4

    @buttonsView.add @facebook
    @buttonsView.add @dwolla
    @buttonsView.add @twitter
    @buttonsView.add @linkedin
    @buttonsView.add @tumblr

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

  buttonForService: (service, index) ->
    vertSpacing = 10
    horizSpacing = 15 

    button = Ti.UI.createButton
      top: 70 * (Math.floor(index/3) + 1) + vertSpacing * Math.floor(index/3) + "dp"
      left: 40 + 65 * (index % 3) + horizSpacing * (index % 3) + "dp"
      width: "65dp"
      height: "65dp"
      title: service

    if service is "dwolla"
      button.addEventListener "click", (event) =>
        connect = new ConnectView
          url: do api.buildDwollaUrl
          close: =>
            do @popModal
            do @updateSeletions
          cancelUrl: "https://www.dwolla.com/"
          
        @showModal connect.view
    else
      button.addEventListener "click", (event) =>
        connect = new ConnectView
          url: api.buildSinglyUrlForService service
          close: =>
            do @popModal
            do @updateSeletions
        @showModal connect.view

    button


  updateSeletions: =>
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