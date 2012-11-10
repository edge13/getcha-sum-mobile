ProgoView = require "ProgoView"
rowFactory = require "RowFactory"
OfferView = require "OfferView"

class OffersList extends ProgoView
  layout: ->
    @table = Ti.UI.createTableView
      height: "100%"
      width: "100%"
      backgroundColor: "blue"

    @view.add @table
    @rows = new Array()

    for i in [0..3]
      @rows.push rowFactory.createOfferRow
        test: "test"

    @table.data = @rows

    @table.addEventListener "click", (e) =>
      offer = new OfferView
        close: @popModal
        offer: e.rowData.offer
      @showModal offer.view

module.exports = new OffersList()