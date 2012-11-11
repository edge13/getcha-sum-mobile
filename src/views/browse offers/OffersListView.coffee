ProgoView = require "ProgoView"
rowFactory = require "RowFactory"
OfferDetailView = require "OfferDetailView"
api = require "api"
RefreshingTable = require "RefreshingTable"

class OffersList extends ProgoView
  layout: ->
    @table = new RefreshingTable
      top: "45dip"
      bottom: 0
      width: "100%"
      backgroundColor: "transparent"
  
    @view.add @table.view

    @logo = Ti.UI.createImageView
      image: "/logo.png"
      left: "12dip"
      top: "8dip"

    @view.add @logo

    @shadow = Ti.UI.createView
      width: "100%"
      top: "45dip"
      height: "18dip"
      left: 0
      backgroundImage: "/topbar-shadow.png"

    @view.add @shadow

    @darkPatch = Ti.UI.createView
      backgroundImage: "/darkbg-stretch.png"
      right: 0
      top: 0
      width: "60dip"
      height: "45dip"

    @view.add @darkPatch

    @magnify = Ti.UI.createImageView
      image: "/search-icon.png"
      top: "8dip"
      right: "12dip"

    @view.add @magnify

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
      @pendingOffer = undefined
      @willSelectIndex = undefined

module.exports = new OffersList()