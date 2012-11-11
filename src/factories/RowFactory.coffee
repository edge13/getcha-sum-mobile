findIcon = (type) ->
  folder = "/serviceIcons/"
  if type is "facebook"
    folder + "facebook-sm.png"
  else if type is "linkedin"
    folder + "in-sm.png"
  else if type is "tumblr"
    folder + "tumblr-sm.png"
  else if type is "twilio"
    folder + "twilio-sm.png"
  else if type is "twitter"
    folder + "twitter-sm.png"

module.exports.createOfferRow = (offer) ->

  row = Ti.UI.createView
    width: "100%"
    height: "95dip"

  title = Ti.UI.createTextArea
    value: do offer.name.toUpperCase
    color: "#ffffff"
    top: "7dip"
    left: "65dip"
    height: "25dip"
    backgroundColor: "transparent"
    font:
      fontFamily: "Avenir LT Std"
      fontSize: "16dip"
    scrollable: false
    editable: false
    touchEnabled: false

  content = Ti.UI.createTextArea
    value: offer.content
    color: "#878787"
    left: "65dip"
    top: "30dip"
    bottom: "12dip"
    right: "15dip"
    editable: false
    backgroundColor: "transparent"
    font:
      fontFamily: "Avenir LT Std"
      fontSize: "12dip"
    scrollable: false
    touchEnabled: false

  border = Ti.UI.createView
    backgroundColor: "#878787"
    width: "100%"
    height: "1dip"
    bottom: 0

  icon = findIcon offer.type

  if icon?
    image = Ti.UI.createImageView
      left: "18dip"
      top: "12dip"
      image: icon
    row.add image

  price = Ti.UI.createLabel
    textAlign: Ti.UI.TEXT_ALIGNMENT_CENTER
    text: offer.price + "¢"
    top: "48dip"
    color: "#d2dd26"
    center:
      x: "32dip"
    font:
      fontFamily: "Avenir LT Std"
      fontSize: "30sp"

  ###
  cent = Ti.UI.createImageView
    left: "36dip"
    image: "/cent.png"
    width: "24dip"
    height: "10dip"
    top: "52dip"
  ###

  row.offer = offer
  row.add title
  row.add content
  row.add border
  row.add price
  #row.add cent

  row