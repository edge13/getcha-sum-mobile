ProgoView = require "ProgoView"
CreateView = require "CreateOffer"
api = require "api"

class MyOffersView extends ProgoView
  layout: ->
    createButton = Ti.UI.createButton
      title: "Create new offer"
      top: "5dip"

    offersTable = Ti.UI.createScrollView
      top: "45dip"
      bottom: 0
      layout: "vertical"
      backgroundColor: "pink"

    createButton.addEventListener "click", (event) =>
      createView = new CreateView
        close: @popModal
      @showModal createView.view

    @view.add createButton
    @view.add offersTable

    api.getMyOffers
      success: (offers) ->
        #add a bunch of rows

module.exports = new MyOffersView()