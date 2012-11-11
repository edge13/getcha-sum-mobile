ProgoView = require "ProgoView"
CreateOfferView = require "CreateOfferView"
RefreshingTable = require "RefreshingTable"
RowFactory = require "RowFactory"
api = require "api"

class MyOffersView extends ProgoView
  layout: ->
    createButton = Ti.UI.createImageView
      top: 0
      image: "/createoffer-btn.png"
      right: 0

    logo = Ti.UI.createImageView
      image: "/logo.png"
      left: "12dip"
      top: "8dip"

    @view.add logo

    shadow = Ti.UI.createView
      width: "100%"
      top: "45dip"
      height: "18dip"
      left: 0
      backgroundImage: "/topbar-shadow.png"

    @view.add shadow

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