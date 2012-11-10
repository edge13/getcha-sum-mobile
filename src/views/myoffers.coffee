ProgoView = require "ProgoView"
CreateView = require "CreateOffer"
api = require "api"

class MyOffersView extends ProgoView
  layout: ->
    ###
    createButton = Ti.UI.createButton
      title: "Create new offer"
      top: "5dip"

    offersTable = Ti.UI.createScrollView
      top: "25dip"
      bottom: 0
      layout: "vertical"


    createButton.addEventListener "click", (event) =>
      createView = new CreateView
        close: @popModal
      @showModal createView.view

    @view.add createButton
    ###

module.exports = new MyOffersView()