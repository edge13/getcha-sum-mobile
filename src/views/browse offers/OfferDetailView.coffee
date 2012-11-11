ModalView = require "ModalView"
Global = require "Global"
api = require "api"

class OfferDetailView extends ModalView
  layout: ->
    @offer = @options.offer
    ###
    @eligible = OfferUtil.eligible Global.me, @options.offer
    Ti.API.info "eligible=" + @eligible
    ###

    cancel = Ti.UI.createLabel
      text: "CANCEL"
      left: "14dip"
      top: "14dip"
      color: "#d2dd26"
      font:
        fontSize: "27sp"
        fontFamily: "Arvil"

    accept = Ti.UI.createLabel
      text: "accept"
      right: "14dip"
      top: "14dip"
      color: "#d2dd26"
      font:
        fontSize: "27sp"
        fontFamily: "Arvil"

    mediaView = Ti.UI.createView
      top: "70dip"
      left: 0
      width: "50%"

    mediaImage = Ti.UI.createImageView
      top: 0
      center:
        x: "50%"
      image: @getLargeIcon @offer.type

    mediaLabel = Ti.UI.createLabel
      text: "USE THIS"
      center:
        x: "50%"
      top: "125dip"
      color: "#d82a2a"
      textAlign: Ti.UI.TEXT_ALIGNMENT_CENTER
      font:
        fontFamily: "Avenir LT Std"
        fontSize: "12sp"

    mediaView.add mediaImage
    mediaView.add mediaLabel

    priceView = Ti.UI.createView
      top: "70dip"
      right: 0
      width: "50%"

    price = Ti.UI.createLabel
      top: 0
      width: "70%"
      left: 0
      text: @offer.price
      color: "#d2dd26"
      textAlign: Ti.UI.TEXT_ALIGNMENT_RIGHT
      font:
        fontSize: "150sp"
        fontFamily: "Arvil"

    cent = Ti.UI.createImageView
      left: "73%"
      top: 0
      image: "/offerdetail/cent.png"

    earnThat = Ti.UI.createLabel
      center:
        x: "50%"
      top: "125dip"
      text: "EARN THAT"
      color: "#d82a2a"
      textAlign: Ti.UI.TEXT_ALIGNMENT_CENTER
      font:
        fontFamily: "Avenir LT Std"
        fontSize: "12sp"

    priceView.add price
    priceView.add cent
    priceView.add earnThat

    progress = Math.max(1, Math.round((@offer.acceptedCount / @offer.cap) * 10))
    
    progressView = Ti.UI.createView
      top: "70dip"
      left: "100%"
      width: "50%"

    progressBackground = Ti.UI.createImageView
      center:
        x: "50%"
      top: 0
      image: "/offerdetail/progress-bg.png"

    progressImage = Ti.UI.createImageView
      center:
        x: "50%"
      top: 0
      image: "/offerdetail/progress-" + progress + ".png"

    width = Ti.Platform.displayCaps.platformWidth

    leftOut = Ti.UI.createAnimation
      right: width
      left: -width
      duration: 600

    rightOver = Ti.UI.createAnimation
      left: 0
      right: width/2
      duration: 600

    rightIn = Ti.UI.createAnimation
      left: width/2
      right: 0
      duration: 600

    current = "media"
    setInterval ->
      if current is "media"
        progressView.left = width
        progressView.animate rightIn
        priceView.animate rightOver
        mediaView.animate leftOut
        current = "price"
      else if current is "price"
        mediaView.left = width
        mediaView.animate rightIn
        progressView.animate rightOver
        priceView.animate leftOut
        current = "progress"
      else
        priceView.left = width
        priceView.animate rightIn
        mediaView.animate rightOver
        progressView.animate leftOut
        current = "media"
    , 3000
    
    progressLabel = Ti.UI.createLabel
      text: @offer.acceptedCount + " OUT OF " + @offer.cap
      center:
        x: "50%"
      top: "125dip"
      color: "#d82a2a"
      textAlign: Ti.UI.TEXT_ALIGNMENT_CENTER
      font:
        fontFamily: "Avenir LT Std"
        fontSize: "12sp"

    progressView.add progressBackground
    progressView.add progressImage
    progressView.add progressLabel

    offerName = Ti.UI.createTextArea
      value: do @offer.name.toUpperCase
      top: "240dip"
      left: "10dip"
      right: "10dip"
      color: "#ffffff"
      font:
        fontSize: "18sp"
        fontFamily: "Avenir LT Std"
      backgroundColor: "transparent"

    offerTextArea = Ti.UI.createTextArea
      editable: false
      value: @offer.content
      top: "265dip"
      left: "10dip"
      right: "10dip"
      color: "#878787"
      font:
        fontSize: "18sp"
        fontFamily: "Avenir LT Std"
      backgroundColor: "transparent"

    accept.addEventListener "click", (e) =>
      if @offer.type is "twilio"
        @showContacts (phoneNumbers) =>
          @accept @offer, phoneNumbers
      else
        @accept @offer

    cancel.addEventListener "click", @options.close

    @view.add accept
    @view.add cancel
    @view.add mediaView
    @view.add priceView
    @view.add progressView
    @view.add offerName
    @view.add offerTextArea

  accept: (offer, phoneNumbers) ->
    options = 
      id: offer.id
      success: (response) =>
        @confirm offer
    if phoneNumbers?
      options.data = 
        phoneNumbers: phoneNumbers
    api.acceptOffer options

  confirm: (offer) ->
    Ti.API.info "creating confirmation"
    curtain = Ti.UI.createView
      width: "100%"
      height: "100%"
      backgroundColor: "#55000000"

    popup = Ti.UI.createImageView
      center:
        x: "50%"
        y: "50%"
      image: "stamp.png"

    sound = Ti.Media.createSound
      url: "chaching.wav"
      preload: true
    do sound.play
 
    curtain.add popup
    @view.add curtain

    setTimeout =>
      @view.remove curtain
      do @options.close
    , 4500

  showContacts: (success) ->
    if Ti.Platform.osname is "iphone"
      Ti.Contacts.showContacts
        fields: ["phone"]
        selectedProperty: (event) =>
          @chooseContact success, event.value
          Ti.API.info JSON.stringify event
    else
      Ti.Contacts.showContacts
        fields: ["phone"]
        selectedPerson: (event) =>
          number = undefined
          if event.person.phone?
            if event.person.phone.mobile?
              Ti.API.info "Contact has mobile"
              number = event.person.phone.mobile
            else
              Ti.API.info "Contact doesn't have mobile"
              for key, value of event.person.phone
                Ti.API.info "Falling back on: " + key
                number = event.person.phone[key]
                break
          @chooseContact success, number
      
          Ti.API.info JSON.stringify event

  chooseContact: (success, number) ->
    Ti.API.info typeof number
    Ti.API.info "Contact chosen with number: " + number
    if number?
      number = "" + number
      number = number.replace " ", ""
      number = number.replace "(", ""
      number = number.replace ")", ""
      number = number.replace "-", ""
      number = "+1" + number
      phones = new Array()
      phones.push number
      success phones
    else
      alert "There was a problem loading contact phone"

  getLargeIcon: (type) ->
    folder = "/offerdetail/"
    if type is "facebook"
      folder + "facebook-lg.png"
    else if type is "linkedin"
      folder + "in-lg.png"
    else if type is "tumblr"
      folder + "tumblr-lg.png"
    else if type is "twilio"
      folder + "twilio-lg.png"
    else if type is "twitter"
      folder + "twitter-lg.png"

module.exports = OfferDetailView