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
        @showContacts =>
          @accept @offer
      else
        @accept offer

    cancelButton.addEventListener "click", @options.close

    @view.add offerTextArea
    @view.add offerName
    @view.add acceptButton
    @view.add cancelButton
    @view.add type
    @view.add price
    @view.add progressBar
    @view.add progressLabel

  accept: (offer) ->
    api.acceptOffer
      id: offer.id
      success: (response) =>
        @confirm offer

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
    if Ti.Contacts.contactsAuthorization is Ti.Contacts.AUTHORIZATION_AUTHORIZED
      @selectContacts success
    else if Ti.Contacts.contactsAuthorization is Ti.Contacts.AUTHORIZATION_UNKNOWN
      Ti.Contacts.requestAuthorization (event) =>
        if event.success
          @selectContacts success
        else
          alert "Unable to access device contacts"
          do @options.close

  selectContacts: (success) ->
    Ti.API.log "selecting contacts"
    people = do Ti.Contacts.getAllPeople
    Ti.API.info JSON.stringify people

    contactsView = Ti.UI.createView
      width: "100%"
      height: "100%"
      backgroundImage: "background.png"

    contactTable = Ti.UI.createTableView
      width: "100%"
      top: "30dip"
      bottom: 0
      backgroundColor: "transparent"

    rows = new Array()
    for person in people
      if person.phone?
        rows.push @createPersonRow person
    contactTable.setData rows

    submit = Ti.UI.createButton
      top: 0
      right: 0
      title: "submit"

    contactsView.add contactTable
    contactsView.add submit
    @view.add contactsView

    submit.addEventListener "click", (event) =>
      #gather selected contacts
      @view.remove contactsView
      do success

  createPersonRow: (person) ->
    person.selected = false
    row = Ti.UI.createTableViewRow
      width: "100%"
      height: "30dip"
    name = Ti.UI.createLabel
      text: person.fullName
      left: 0
    status = Ti.UI.createLabel
      text: "off"
      right: 0
    row.addEventListener "click", (event) ->
      person.selected = !person.selected
      if person.selected
        status.text = "on"
      else
        status.text = "off"
    row.add name
    row.add status
    row

module.exports = OfferDetailView