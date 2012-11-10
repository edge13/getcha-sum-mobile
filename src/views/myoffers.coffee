ProgoView = require "ProgoView"
CreateView = require "CreateOffer"
api = require "api"

class MyOffersView extends ProgoView
  layout: ->
    createButton = Ti.UI.createButton
      title: "Create new offer"
      top: "5dip"

    createButton.addEventListener "click", (event) =>
      createView = new CreateView
        close: =>
          do @popModal
          do @onShow
      @showModal createView.view

    @offersTable = Ti.UI.createTableView
      top: "45dip"
      bottom: 0
      minRowHeight: "40dip"
      maxRowHeight: "40dip"
      backgroundColor: "pink"

    @view.add @offersTable
    @view.add createButton

  onShow: ->
    api.getMyOffers
      success: (offers) =>
        rows = new Array()
        for offer in offers
          rows.push @createOfferRow offer
        @offersTable.setData rows
        #add a bunch of rows

  createOfferRow: (offer) ->
    row = Ti.UI.createTableViewRow
      height: "40dip"
      
    label = Ti.UI.createLabel
      left: "10dip"
      top: "5dip"
      text: offer.name
    row.add label
    row

module.exports = new MyOffersView()