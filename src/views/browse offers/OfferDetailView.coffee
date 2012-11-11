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

    price = Ti.UI.createLabel
      top: "70dip"
      right: "67%"
      left: 0
      text: @offer.price
      color: "#d2dd26"
      textAlign: Ti.UI.TEXT_ALIGNMENT_RIGHT
      font:
        fontSize: "150sp"
        fontFamily: "Arvil"

    cent = Ti.UI.createImageView
      left: "36%"
      top: "70dip"
      image: "/offerdetail/cent.png"

    earnThat = Ti.UI.createLabel
      center:
        x: "24%"
      top: "195dip"
      text: "EARN THAT"
      color: "#d82a2a"
      font:
        fontFamily: "Avenir LT Std"
        fontSize: "12sp"

    progress = Math.max(1, Math.round((@offer.acceptedCount / @offer.cap) * 10))
    
    Ti.API.info "Accepted count=" + @offer.acceptedCount
    Ti.API.info "progress=" + progress

    progressBackground = Ti.UI.createImageView
      center:
        x: "76%"
      top: "70dip"
      image: "/offerdetail/progress-bg.png"

    progressImage = Ti.UI.createImageView
      center:
        x: "76%"
      top: "70dip"
      image: "/offerdetail/progress-" + progress + ".png"

    setInterval ->
      progress = Math.min(10, progress+1)
      progressImage.image = "/offerdetail/progress-" + progress + ".png"
    , 1000

    progressLabel = Ti.UI.createLabel
      text: @offer.acceptedCount + " OUT OF " + @offer.cap
      center:
        x: "76%"
      top: "195dip"
      color: "#d82a2a"
      font:
        fontFamily: "Avenir LT Std"
        fontSize: "12sp"

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
    #@view.add type
    @view.add cent
    @view.add price
    @view.add earnThat
    @view.add progressBackground
    @view.add progressImage
    @view.add progressLabel
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
    curtain = Ti.UI.createView
      width: "100%"
      height: "100%"
      backgroundColor: "#55000000"

    popup = Ti.UI.createView
      width: "95%"
      height: "150dip"
      backgroundColor: "white"

    text = Ti.UI.createLabel
      text: "Congrats"

    popup.add text
    curtain.add popup
    @view.add curtain

    setTimeout =>
      @view.remove curtain
      do @options.close
    , 3000

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

module.exports = OfferDetailView