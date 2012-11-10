ModalView = require "ModalView"
api = require "api"

class ConfirmCreateView extends ModalView
  layout: ->
    instruct = Ti.UI.createLabel
      text: "Confirm your PIN"
      top: "10dip"

    pin = Ti.UI.createLabel
      width: "90%"
      top: "30dip"
      height: "50dip"
      font:
        fontSize: "25sp"
      passwordMask: true

    pin.addEventListener "change", (event) =>
      if pin.value.length is 4
        #show spinner
        @options.offer.pin = pin.value
        api.createOffer
          data: @options.offer
          success: (response) =>
            do @options.close

    @view.add instruct
    @view.add pin

module.exports = ConfirmCreateView