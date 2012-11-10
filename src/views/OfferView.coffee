ModalView = require "ModalView"

class OfferView extends ModalView
  layout: ->
    offerTextArea = Ti.UI.createTextArea
      width: "80%"
      height: "200dp"
      editable: false
      value: "this is a \n test \n description \n\n\n\n with multiple lines"
      top: "50dp"


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