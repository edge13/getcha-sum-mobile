ProgoView = require "ProgoView"
rowFactory = require "RowFactory"
OfferView = require "OfferView"
api = require "api"

RefreshingTable = require "RefreshingTable"

class OffersList extends ProgoView
  layout: ->
    @table = new RefreshingTable
      height: "100%"
      width: "100%"
      backgroundColor: "blue"
  
    @view.add @table.view

    @table.onRowClicked = (e) =>
      offer = new OfferView
        close: @popModal
        offer: e.rowData.offer
      @showModal offer.view

    @table.beginReloading = @onShow

  onShow: =>
    api.getAllOffers
      success: (data) =>
        @showOffers data

  showOffers: (@offers) ->
    @rows = new Array()

    for offer in @offers
      continue unless offer.content? or offer.content.length is 0
      row = rowFactory.createOfferRow offer
      @rows.push row

    @table.setData @rows

    do @table.endReloading if @table.reloading

module.exports = new OffersList()