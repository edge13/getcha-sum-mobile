module.exports.createOfferRow = (offer) ->

  row = Ti.UI.createTableViewRow
    width: "100%"
    height: "30dp"

  label = Ti.UI.createLabel
    text: "test row"

  row.add label

  row