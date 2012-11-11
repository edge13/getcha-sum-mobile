ProgoView = require "ProgoView"
ModalView = require "ModalView"
api = require "api"

class CreateOfferView extends ModalView
  layout: ->
    @types = ["TWITTER"]

    container = Ti.UI.createScrollView
      width: "100%"
      height: "100%"
      contentWidth: "100%"
      contentHeight: "100%"

    @instruct = Ti.UI.createLabel
      top: "5dip"
      text: "Create an offer"

    @name = Ti.UI.createTextField
      hintText: "offer name/descript"
      width: "90%"
      height: "20dip"
      borderColor: "#000000"
      borderWidth: "1dip"
      top: "30dip"

    @content = Ti.UI.createTextArea
      width: "90%"
      height: "60dip"
      top: "60dip"
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

    @submit = Ti.UI.createButton
      top: "200dip"
      title: "Submit"

    @submit.addEventListener "click", (event) =>
      offer = {}
      offer.name = @name.value
      offer.content = @content.value
      offer.type = "twitter"
      offer.price = parseFloat @price.value
      offer.cap = parseInt @count.value
      @confirm offer

    container.add @instruct
    container.add @name
    container.add @price
    container.add @content
    container.add @count
    container.add @submit

    @view.add container

  confirm: (offer) ->
    container = Ti.UI.createView
      width: "100%"
      height: "100%"
      backgroundColor: "green"

    instruct = Ti.UI.createLabel
      text: "Confirm your PIN"
      top: "10dip"

    pin = Ti.UI.createTextField
      width: "90%"
      top: "30dip"
      height: "50dip"
      font:
        fontSize: "25sp"
      passwordMask: true
      borderColor: "#000000"
      borderWidth: "1dip"

    pin.addEventListener "change", (event) =>
      if pin.value.length is 4
        #show spinner
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