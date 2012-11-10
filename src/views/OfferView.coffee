ModalView = require "ModalView"

class OfferView extends ModalView
  layout: ->
    offerNameLabel = Ti.UI.createLabel
      text: "Offer name"
      top: "20dp"
      width: "100dp"
      left: "10dp"

    offerName = Ti.UI.createLabel
      text: @options.offer.name
      top: "20dp"
      width: "180dp"
      left: "140dp"

    @view.add offerNameLabel
    @view.add offerName

    offerTextArea = Ti.UI.createTextArea
      width: "80%"
      height: "200dp"
      editable: false
      value: @options.offer.content
      top: "50dp"
      backgroundColor: "transparent"

    @view.add offerTextArea

    acceptButton = Ti.UI.createButton
      title: "accept"
      left: "10%"
      top: "300dp"

    cancelButton = Ti.UI.createButton
      title: "cancel"
      right: "10%"
      top: "300dp"

    acceptButton.addEventListener "click", (e) =>
      Ti.API.info "wanting to accept offerTextArea"
      do @options.close

    cancelButton.addEventListener "click", @options.close

    @view.add acceptButton
    @view.add cancelButton

module.exports = OfferView