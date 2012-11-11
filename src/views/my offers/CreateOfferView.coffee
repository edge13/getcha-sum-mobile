ProgoView = require "ProgoView"
ModalView = require "ModalView"
api = require "api"

class CreateOfferView extends ModalView
  layout: ->
    @type = "TWITTER"

    container = Ti.UI.createScrollView
      width: "100%"
      height: "100%"
      contentWidth: "100%"
      contentHeight: "100%"

    @instruct = Ti.UI.createLabel
      top: "5dip"
      text: "Create an offer"

    @name = Ti.UI.createTextField
      hintText: "OFFER NAME"
      width: "87%"
      height: "27dip"
      backgroundImage: "createOffer/text-createOffername.png"
      top: "50dip"
      font:
        fontSize: "27sp"
        fontFamily: "Arvil"

    @buttonsArea = Ti.UI.createView
      top: "90dp"
      height: "60dp"
      width: "90%"
      layout: "horizontal"

    @content = Ti.UI.createTextArea
      width: "90%"
      height: "60dip"
      top: "600dip"
      hintText: "content"
      borderColor: "#000000"
      borderWidth: "1dip"
      suppressReturn: false

    @price = Ti.UI.createTextField
      top: "140dip"
      keyboardType: Titanium.UI.KEYBOARD_DECIMAL_PAD
      hintText: "Price per"
      borderColor: "#000000"
      borderWidth: "1dip"

    @count = Ti.UI.createTextField
      top: "170dip"
      keyboardType: Titanium.UI.KEYBOARD_NUMBER_PAD
      hintText: "Count"
      borderColor: "#000000"
      borderWidth: "1dip"      

    @buttons = new Array()

    @twitter = Ti.UI.createImageView
      image: "createOffer/twitter-med.png"
      left: 0
    @twitter.regImage = "createOffer/twitter-med.png"
    @twitter.selectedImage = "createOffer/twitter-med-active.png"

    @facebook = Ti.UI.createImageView
      image: "createOffer/facebook-med.png"
      left: "20dp"
    @facebook.regImage = "createOffer/facebook-med.png"
    @facebook.selectedImage = "createOffer/facebook-med-active.png"

    @tumblr = Ti.UI.createImageView
      image: "createOffer/tumblr-med.png"
      left: "20dp" 
    @tumblr.regImage = "createOffer/tumblr-med.png"
    @tumblr.selectedImage = "createOffer/tumblr-med-active.png"

    @twilio = Ti.UI.createImageView
      image: "createOffer/twillo-med.png"
      left: "20dp"
    @twilio.regImage = "createOffer/twillo-med.png"
    @twilio.selectedImage = "createOffer/twillo-med-active.png"

    @linkedin = Ti.UI.createImageView
      image: "createOffer/linkedin-med.png"
      left: "20dp"
    @linkedin.regImage = "createOffer/linkedin-med.png"
    @linkedin.selectedImage = "createOffer/linkedin-med-active.png"

    @buttons.push @twitter
    @buttons.push @facebook
    @buttons.push @tumblr
    @buttons.push @twilio
    @buttons.push @linkedin

    @buttonsArea.add @twitter
    @buttonsArea.add @facebook
    @buttonsArea.add @tumblr
    @buttonsArea.add @twilio
    @buttonsArea.add @linkedin

    @twitter.addEventListener "click", (event) =>
      do @clearButtons
      @type = "twitter"
      @twitter.image = @twitter.selectedImage

    @twilio.addEventListener "click", (event) =>
      do @clearButtons
      @type = "twilio"
      @twilio.image = @twilio.selectedImage

    @facebook.addEventListener "click", (event) =>
      do @clearButtons
      @type = "facebook"
      @facebook.image = @facebook.selectedImage

    @tumblr.addEventListener "click", (event) =>
      do @clearButtons
      @type = "tumblr"
      @tumblr.image = @tumblr.selectedImage

    @linkedin.addEventListener "click", (event) =>
      do @clearButtons
      @type = "linkedin"
      @linkedin.image = @linkedin.selectedImage

    @cancel = Ti.UI.createLabel
      text: "CANCEL"
      left: "14dip"
      top: "14dip"
      color: "#d2dd26"
      font:
        fontSize: "27sp"
        fontFamily: "Arvil"
    @cancel.addEventListener "click", @options.close

    @accept = Ti.UI.createLabel
      text: "accept"
      right: "14dip"
      top: "14dip"
      color: "#d2dd26"
      font:
        fontSize: "27sp"
        fontFamily: "Arvil"

    @accept.addEventListener "click", (event) =>
      offer = {}
      offer.name = @name.value
      offer.content = @content.value
      offer.type = @type
      offer.price = parseFloat @price.value
      offer.cap = parseInt @count.value
      @confirm offer

    container.add @instruct
    container.add @name
    container.add @price
    container.add @content
    container.add @count
    container.add @cancel
    container.add @buttonsArea
    container.add @accept
    @view.add container

  clearButtons: =>
    for button in @buttons
      button.image = button.regImage
  confirm: (offer) ->
    container = Ti.UI.createView
      width: "100%"
      height: "100%"
      backgroundImage: "/background.png"

    instruct = Ti.UI.createLabel
      text: "CONFIRM  YOUR PIN"
      top: "20dip"
      color: "white"
      font:
        fontFamily: "Avenir LT Std"
        fontSize: "18dip"

    pin = Ti.UI.createTextField
      width: "40%"
      top: "70dip"
      height: "50dip"
      textAlign: Ti.UI.TEXT_ALIGNMENT_CENTER
      font:
        fontFamily: "Arvil"
        fontSize: "44dip"
      passwordMask: true
      backgroundImage: "/text-createoffername.png"

    pin.addEventListener "change", (event) =>
      if pin.value.length is 4
        container.remove pin
        offer.pin = pin.value
        api.createOffer
          data: offer
          success: (response) =>
            do @options.close
          failure: (code, text) =>
            @view.remove container

    container.add instruct
    container.add pin
    @view.add container

    do pin.focus

module.exports = CreateOfferView