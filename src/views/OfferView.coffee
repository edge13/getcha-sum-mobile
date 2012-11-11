ModalView = require "ModalView"
OfferUtil = require "OfferUtil"
Global = require "Global"
api = require "api"

class OfferView extends ModalView
  layout: ->
    @offer = @options.offer
    @eligible = OfferUtil.eligible Global.me, @options.offer
    Ti.API.info "eligible=" + @eligible

    offerName = Ti.UI.createTextArea
      value: @offer.name
      top: "70dp"
      width: "80%" 
      height: "40dip"
      editable: false

    type = Ti.UI.createImageView
      left: "10%"
      top: "120dip"
      width: "60dip"
      height: "60dip"
      backgroundColor: "pink"

    price = Ti.UI.createImageView
      right: "10%"
      top: "120dip"
      width: "60dip"
      height: "60dip"
      backgroundColor: "pink"

    offerTextArea = Ti.UI.createTextArea
      width: "80%"
      height: "120dp"
      editable: false
      value: @offer.content
      top: "200dip"

    acceptButton = Ti.UI.createButton
      title: "accept"
      right: 0
      top: 0

    cancelButton = Ti.UI.createButton
      title: "cancel"
      left: 0
      top: 0

    Ti.API.info "Accepted count=" + @offer.acceptedCount

    ratio = @offer.acceptedCount / @offer.cap

    Ti.API.info "ratio=" + ratio

    progressBar = Ti.UI.createImageView
      left: "10%"
      top: "340dip"
      width: "190dip"
      height: "30dip"
      backgroundColor: "pink"

    progressLabel = Ti.UI.createLabel
      text: @offer.cap
      right: "10%"
      top: "340dip"

    acceptButton.addEventListener "click", (e) =>
      api.acceptOffer
        id: @offer.id
        success: (response) =>
          @confirm @offer

    cancelButton.addEventListener "click", @options.close

    @view.add offerTextArea
    @view.add offerName
    @view.add acceptButton
    @view.add cancelButton
    @view.add type
    @view.add price
    @view.add progressBar
    @view.add progressLabel

  confirm: (offer) ->
    curtain = Ti.UI.createView
      width: "100%"
      height: "100%"
      backgroundColor: "#55000000"

    popup = Ti.UI.createView
      width: "95%"
      height: "150dip"
      backgroundColor: "white"

    text = Ti.UI.createLabel
      text: "Congrats"

    popup.add text
    curtain.add popup
    @view.add curtain

    setTimeout =>
      @view.remove curtain
      do @options.close
    , 3000

module.exports = OfferView