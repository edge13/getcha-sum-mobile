api = require "api"
ConnectView = require "ConnectView"
ProgoView = require "ProgoView"
Global = require "Global"
UserUtil = require "UserUtil"

class AccountView extends ProgoView
  layout: ->
    @containerView = Ti.UI.createScrollView
      showVerticalScrollIndicator: false
      height: "100%"
      width: "100%"
      layout: "vertical"

    @buttonsView = Ti.UI.createView
      height: Ti.UI.SIZE
      backgroundColor: "transparent"
      width: "100%"
      top: "40dp"

    @dwolla = @buttonForService "dwolla", 0
    @twitter = @buttonForService "twitter", 1
    @facebook = @buttonForService "facebook", 2
    @linkedin = @buttonForService "linkedin", 3
    @twilio = @buttonForService "twillo", 4
    @tumblr = @buttonForService "tumblr", 5

    @dwollaLabel = @labelForIndex "DWOLLA", 0

    @twitterLabel = @labelForIndex "TWITTER", 1

    @facebookLabel = @labelForIndex "FACEBOOK", 2

    @linkedinLabel = @labelForIndex "LINKEDIN", 3

    @tumblrLabel = @labelForIndex "TUMBLR", 5

    @twilioLabel = @labelForIndex "TWILIO", 4


    @buttonsView.add @facebook
    @buttonsView.add @dwolla
    @buttonsView.add @twitter
    @buttonsView.add @linkedin
    @buttonsView.add @tumblr
    @buttonsView.add @twilio

    @buttonsView.add @dwollaLabel
    @buttonsView.add @twitterLabel
    @buttonsView.add @facebookLabel
    @buttonsView.add @linkedinLabel
    @buttonsView.add @tumblrLabel
    @buttonsView.add @twilioLabel

    @view.add @containerView
    @containerView.add @buttonsView

    @emailView = Ti.UI.createView
      top: "25dp"
      height: Ti.UI.SIZE
      width: "100%"
      backgroundColor: "transparent"

    @userIcon = Ti.UI.createImageView
      image: "account/user-icon.png"
      left: "25dp"

    @emailView.add @userIcon

    @emailLabel = Ti.UI.createLabel
      backgroundImage: "account/text-email.png"
      height: "30dp"
      width: "220dp"
      left: "80dp"
      color: "white"
      font:
        fontFamily: "Arvil"
        fontSize: "14sp"
      backgroundPaddingLeft: 2
    @emailView.add @emailLabel
    @containerView.add @emailView

    @genderSelectView = Ti.UI.createView
      backgroundColor: "transparent"
      top: "25dp"
      height: Ti.UI.SIZE
      layout: "horizontal"

    @containerView.add @genderSelectView

    @femaleLabel = Ti.UI.createLabel
      left: "25dp"
      font:
        fontFamily: "Arvil"
        fontSize: "16sp"
      color: "#d2dd26"
      text: "Female"

    @femaleBox = Ti.UI.createImageView
      image: "account/text-sex.png"
      hires: true
      left: "10dp"
      height: "35dp"
      width: "35dp"
    @femaleBox.checked = false

    @maleLabel = Ti.UI.createLabel
      font:
        fontFamily: "Arvil"
        fontSize: "16sp"
      color: "#d2dd26"
      text: "Male"
      left: "23dp"

    @maleBox = Ti.UI.createImageView
      image: "account/text-sex.png"
      left: "10dp"
      height: "35dp"
      width: "35dp"
      hires: true
    @maleBox.checked = false

    @femaleBox.addEventListener "click", (e) =>
      return if @femaleBox.checked

      if @maleBox.checked
        @maleBox.image = "account/text-sex.png"
        @maleBox.checked = false

      @femaleBox.checked = true
      @femaleBox.image = "account/text-sex-check.png"

    @maleBox.addEventListener "click", (e) =>

      return if @maleBox.checked

      if @femaleBox.checked
        @femaleBox.image = "account/text-sex.png"
        @femaleBox.checked = false

      @maleBox.checked = true
      @maleBox.image = "account/text-sex-check.png"

    @gottaLabel = Ti.UI.createLabel
      text: "(GOTTA PICK ONE)"
      font:
        fontFamily: "Arvil"
        fontSize: "16sp"
      color: "#d2dd26"
      left: "23dp"

    @genderSelectView.add @femaleLabel
    @genderSelectView.add @femaleBox
    @genderSelectView.add @maleLabel
    @genderSelectView.add @maleBox
    @genderSelectView.add @gottaLabel


    @ageView = Ti.UI.createView
      backgroundColor: "transparent"
      top: "25dp"
      height: Ti.UI.SIZE

    @ageLabel = Ti.UI.createLabel
      text: "How old are you?"
      font:
        fontFamily: "Arvil"
        fontSize: "16sp"
      color: "#d2dd26"
      left: "25dp"


    @ageTextField = Ti.UI.createTextField
      backgroundImage: "account/text-age.png"
      width: "182dp"
      height: "30dp"
      left: "115dp"
      keyboardType: Ti.UI.KEYBOARD_DECIMAL_PAD
      font:
        fontFamily: "Arvil"
        fontSize: "16sp"
      color: "#d2dd26"

    @ageTextField.addEventListener "change", (e) =>
      if @ageTextField.value.length is 2
        do @ageTextField.blur


    @ageView.add @ageLabel
    @ageView.add @ageTextField
    @containerView.add @ageView

    do @updateAccounts

  buttonForService: (service, index) ->
    vertSpacing = 10
    horizSpacing = 15 
    if index % 3 is 0
      leftVal = "20%"
    else if index % 3 is 1
      leftVal = "50%"
    else
      leftVal = "80%"

    button = Ti.UI.createImageView
      top: 70 * (Math.floor(index/3)) + vertSpacing * Math.floor(index/3) + "dp"
      center:
        x: leftVal
      image: "account/#{service}.png"
      hires: true

    return if service is "twilio"
    if service is "dwolla"
      button.addEventListener "click", (event) =>
        connect = new ConnectView
          url: do api.buildDwollaUrl
          close: =>
            do @popModal
            do @update
          cancelUrl: "https://www.dwolla.com/"
          
        @showModal connect.view
    else
      button.addEventListener "click", (event) =>
        connect = new ConnectView
          url: api.buildSinglyUrlForService service
          close: =>
            do @popModal
            do @update
        @showModal connect.view

    button


  labelForIndex: (service, index) ->
    vertSpacing = 10
    vertSpacing1 = 55

    if index % 3 is 0
      leftVal = "20%"
    else if index % 3 is 1
      leftVal = "50%"
    else
      leftVal = "80%"

    label = Ti.UI.createLabel
      top: 70 * (Math.floor(index/3)) + vertSpacing * Math.floor(index/3) + vertSpacing1 + "dp"
      center:
        x: leftVal
      textColor: "white"
      font:
        fontFamily: "Arvil"
        fontSize: "14sp"
      color: "white"
      text: service
    label

  update: =>
    api.getMe
      success: (me) =>
        Global.me = me
        do @updateAccounts

  updateAccounts: =>
    Ti.API.info Global.me
    return unless Global.me?
    @emailLabel.text = Global.me.email

    @buttonsView.remove @dwollaLabel
    if Global.me.dwollaAccessToken?
      @dwolla.image = "account/dwolla-active.png"
      @dwollaLabel = @labelForIndex Global.me.dwollaName, 0
    else
      @dwolla.image = "account/dwolla.png"
      @dwollaLabel = @labelForIndex "DWOLLA", 0
    @buttonsView.add @dwollaLabel

    twitterAlias = UserUtil.twitterAlias Global.me
    @buttonsView.remove @twitterLabel
    if twitterAlias?
      @twitter.image = "account/twitter-active.png"
      @twitterLabel = @labelForIndex twitterAlias.name, 1
    else
      @twitter.image = "account/twitter.png"
      @twitterLabel = @labelForIndex "TWITTER", 1
    @buttonsView.add @twitterLabel 

    facebookAlias = UserUtil.facebookAlias Global.me
    @buttonsView.remove @facebookLabel
    if facebookAlias?
      @facebook.image = "account/facebook-active.png"
      @facebookLabel = @labelForIndex facebookAlias.name, 2
    else
      @facebook.image = "account/facebook.png"
      @facebookLabel = @labelForIndex "FACEBOOK", 2
    @buttonsView.add @facebookLabel

    linkedInAlias = UserUtil.linkedInAlias Global.me
    @buttonsView.remove @linkedinLabel
    if linkedInAlias?
      @linkedin.image = "account/linkedin-active.png"
      @linkedinLabel = @labelForIndex linkedInAlias.name, 3
    else
      @linkedin.image = "account/linkedin.png"
      @linkedinLabel = @labelForIndex "LINKEDIN", 3
    @buttonsView.add @linkedinLabel

    tumblrAlias = UserUtil.tumblrAlias Global.me
    @buttonsView.remove @tumblrLabel
    if tumblrAlias?
      @tumblr.image = "account/tumblr-active.png"
      @tumblrLabel = @labelForIndex tumblrAlias.name, 5
    else
      @tumblr.image = "account/tumblr.png"
      @tumblrLabel = @labelForIndex "TUMBLR", 5
    @buttonsView.add @tumblrLabel
  onShow: ->
    do @update

module.exports = new AccountView()