ProgoView = require "ProgoView"

class OfferView extends ProgoView

  layout: ->
    label = Ti.UI.createLabel
      text: "offersview"

    @view.add label


module.exports = OfferView