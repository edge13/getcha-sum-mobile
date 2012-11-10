ProgoView = require "ProgoView"

class ConfirmationView extends ProgoView

  layout: ->
    label = Ti.UI.createLabel
      text: "confirmation"

    @view.add label

module.exports = ConfirmationView