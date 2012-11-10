ProgoView = require "ProgoView"
CreateView = require "CreateOffer"
api = require "api"

class MyOffersView extends ProgoView
  layout: ->
    createButton = Ti.UI.createButton
      title: "Create new offer"

    createButton.addEventListener "click", (event) =>
      createView = new CreateView
        close: @popModal
      @showModal createView.view

    @view.add @createButton

module.exports = new MyOffersView()