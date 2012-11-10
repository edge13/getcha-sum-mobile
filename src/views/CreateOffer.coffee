ProgoView = require "ProgoView"
ModalView = require "ModalView"
api = require "api"

class CreateOffersView extends ModalView
  layout: ->
    @types = ["TWITTER"]

    @container = Ti.UI.createScrollView
      width: "100%"
      height: "100%"
      contentWidth: "100%"
      contentHeight: "100%"

    @instruct = Ti.UI.createLabel
      top: "5dip"
      text: "Create an offer"

    @content = Ti.UI.createTextArea
      width: "90%"
      height: "60dip"
      top: "30dip"
      hintText: "content"
      borderColor: "#000000"
      borderWidth: "1dip"
      suppressReturn: false

    @price = Ti.UI.createTextField
      top: "120dip"
      keyboardType: Titanium.UI.KEYBOARD_DECIMAL_PAD
      hintText: "Price per"
      borderColor: "#000000"
      borderWidth: "1dip"

    @count = Ti.UI.createTextField
      top: "140dip"
      keyboardType: Titanium.UI.KEYBOARD_NUMBER_PAD
      hintText: "Count"
      borderColor: "#000000"
      borderWidth: "1dip"      

    @submit = Ti.UI.createButton
      top: "160dip"
      title: "Submit"

    @submit.addEventListener "click", (event) =>
      offer = {}
      offer.content = @content.value
      offer.type = "TWITTER"
      offer.price = parseFloat @price.value
      offer.cap = parseInt @count.value

      api.createOffer
        data: offer
        success: (response) =>
          do @options.close

    @container.add @instruct
    @container.add @price
    @container.add @content
    @container.add @count
    @container.add @submit

    @view.add @container

module.exports = CreateOffersView