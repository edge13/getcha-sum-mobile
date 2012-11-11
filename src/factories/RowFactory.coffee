module.exports.createOfferRow = (offer) ->

  row = Ti.UI.createView
    width: "100%"
    height: "200dp"
  row.rowHeight = 200

  label = Ti.UI.createLabel
    text: offer.content

  row.offer = offer
  row.add label

  row