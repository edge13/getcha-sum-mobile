ProgoView = require "ProgoView"
CreateOfferView = require "CreateOfferView"
RefreshingTable = require "RefreshingTable"
api = require "api"

class MyOffersView extends ProgoView
  layout: ->
    createButton = Ti.UI.createButton
      title: "Create new offer"
      top: "5dip"

    createButton.addEventListener "click", (event) =>
      createView = new CreateOfferView
        close: =>
          do @popModal
          do @onShow
      @showModal createView.view

    @offersTable = new RefreshingTable
      top: "45dip"
      bottom: 0
      backgroundColor: "pink"

    @offersTable.beginReloading = @onShow
    @offersTable.onRowClicked = (e) =>
      #do something?
      alert "you clicked an offer you own"

    @view.add @offersTable.view
    @view.add createButton

  onShow: =>
    api.getMyOffers
      success: (offers) =>
        @myOffers = offers
        rows = new Array()
        for offer in offers
          rows.push @createOfferRow offer
        @offersTable.setData rows
        if @offersTable.reloading
          do @offersTable.endReloading
        #add a bunch of rows

  createOfferRow: (offer) ->
    row = Ti.UI.createView
      height: "40dip"
      
    label = Ti.UI.createLabel
      left: "10dip"
      top: "5dip"
      text: offer.name
    row.add label
    row

module.exports = new MyOffersView()