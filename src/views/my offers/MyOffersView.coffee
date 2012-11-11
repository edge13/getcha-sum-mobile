ProgoView = require "ProgoView"
CreateOfferView = require "CreateOfferView"
RefreshingTable = require "RefreshingTable"
RowFactory = require "RowFactory"
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
      backgroundColor: "transparent"

    @offersTable.beginReloading = @onShow
    @offersTable.onRowClicked = (e) =>
      #do something?
      alert "you clicked an offer you own"

    @offersTable.addToView @view
    @view.add createButton

  onShow: =>
    api.getMyOffers
      success: (offers) =>
        @myOffers = offers
        rows = new Array()
        for offer in offers
          rows.push RowFactory.createOfferRow offer
        @offersTable.setData rows
        if @offersTable.reloading
          do @offersTable.endReloading
        #add a bunch of rows

module.exports = new MyOffersView()