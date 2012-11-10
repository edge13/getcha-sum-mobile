ProgoView = require "ProgoView"
rowFactory = require "RowFactory"

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

module.exports = OffersList