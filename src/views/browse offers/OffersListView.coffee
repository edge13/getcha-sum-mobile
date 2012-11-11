ProgoView = require "ProgoView"
rowFactory = require "RowFactory"
OfferDetailView = require "OfferDetailView"
api = require "api"
RefreshingTable = require "RefreshingTable"

class OffersList extends ProgoView
  layout: ->
    @table = new RefreshingTable
      height: "100%"
      width: "100%"
      backgroundColor: "transparent"
  
    @view.add @table.view

    @table.onRowClicked = (e) =>
      offer = new OfferDetailView
        close: @popModal
        offer: e.rowData.offer
      @showModal offer.view
      Ti.API.info "showing offer"

    @table.beginReloading = @onShow

  onShow: =>
    api.getAllOffers
      success: (data) =>
        @showOffers data

  showOfferDetail: (@pendingOffer) ->
    Ti.API.info "will show offer detail"
  showOffers: (@offers) ->
    @rows = new Array()

    for offer, i in @offers
      if @pendingOffer?
        if offer.id is @pendingOffer.id
          @willSelectIndex = i
      continue unless offer.content? or offer.content.length is 0
      row = rowFactory.createOfferRow offer
      @rows.push row

    @table.setData @rows

    do @table.endReloading if @table.reloading

    Ti.API.info @pendingOffer
    Ti.API.info @willSelectIndex
    if @pendingOffer? and @willSelectIndex?
      @table.selectRow @willSelectIndex

module.exports = new OffersList()