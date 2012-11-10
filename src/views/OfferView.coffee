ModalView = require "ModalView"

class OfferView extends ModalView
  layout: ->
    button = Ti.UI.createButton
      title: "back"

    button.addEventListener "click", @options.close

    @view.add button


module.exports = OfferView