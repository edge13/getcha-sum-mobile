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

    offerName = Ti.UI.createTextArea
      value: @offer.name
      top: "70dp"
      width: "80%" 
      height: "40dip"
      editable: false

    type = Ti.UI.createImageView
      left: "10%"
      top: "120dip"
      width: "60dip"
      height: "60dip"
      backgroundColor: "pink"

    price = Ti.UI.createImageView
      right: "10%"
      top: "120dip"
      width: "60dip"
      height: "60dip"
      backgroundColor: "pink"

    offerTextArea = Ti.UI.createTextArea
      width: "80%"
      height: "120dp"
      editable: false
      value: @offer.content
      top: "200dip"

    acceptButton = Ti.UI.createButton
      title: "accept"
      right: 0
      top: 0

    cancelButton = Ti.UI.createButton
      title: "cancel"
      left: 0
      top: 0

    ratio = @offer.acceptedCount / @offer.cap
    widthPercent = 80 * ratio
    Ti.API.info "Accepted count=" + @offer.acceptedCount
    Ti.API.info "ratio=" + ratio
    Ti.API.info "widthPercent=" + widthPercent

    progressBar = Ti.UI.createImageView
      left: "10%"
      top: "340dip"
      width: widthPercent + "%"
      height: "30dip"
      backgroundColor: "pink"

    progressLabel = Ti.UI.createLabel
      text: @offer.cap
      right: "10%"
      top: "340dip"

    acceptButton.addEventListener "click", (e) =>
      if @offer.type is "twilio"
        @showContacts (phoneNumbers) =>
          @accept @offer, phoneNumbers
      else
        @accept @offer

    cancelButton.addEventListener "click", (e) =>
      Ti.API.info "clicking close #{JSON.stringify(@options)}"
      do @options.close

    @view.add offerTextArea
    @view.add offerName
    @view.add acceptButton
    @view.add cancelButton
    @view.add type
    @view.add price
    @view.add progressBar
    @view.add progressLabel

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
        selectedProperty: (event) ->
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
    ###
    if Ti.Contacts.contactsAuthorization is Ti.Contacts.AUTHORIZATION_AUTHORIZED
      @selectContacts success
    else if Ti.Contacts.contactsAuthorization is Ti.Contacts.AUTHORIZATION_UNKNOWN
      Ti.Contacts.requestAuthorization (event) =>
        Ti.API.info "contacts requested: result=" + JSON.stringify event
        if event.success
          @selectContacts success
        else
          alert "Unable to access device contacts"
          do @options.close
    ###
  

module.exports = OfferDetailView