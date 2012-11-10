module.exports.createOfferRow = (offer) ->

  row = Ti.UI.createTableViewRow
    width: "100%"
    height: "200dp"

  label = Ti.UI.createLabel
    text: offer.content

  row.offer = offer
  row.add label

  row