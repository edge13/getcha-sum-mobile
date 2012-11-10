class Api
  constructor: ->
    @host = "http://progoserver.appspot.com/"
    @token = undefined

  login: (options) ->
    options.path = "users/login"
    @post options

  getMe: (options) ->
    options.path = "users/me"
    @get options

  getAllOffers: (options) ->
    options.path = "offers"
    @get options

  createOffer: (options) ->
    options.path = "offers"
    @post options

  getMyOffers: (options) ->
    options.path = "users/me/offers"
    @get options

  get: (options) ->
    @request "GET", options

  post: (options) ->
    @request "POST", options

  request: (method, options) ->
    client = Ti.Network.createHTTPClient
      onload: (event) ->
        Ti.API.info "Api success"
        Ti.API.info "Result: " + client.responseText
        options.success JSON.parse client.responseText
      onerror: (error) ->
        alert "Api error"
        Ti.API.info "Error status: " + client.status
        Ti.API.info "Error text:" + client.responseText
        options.failure client.status, client.responseText
      timeout: 10000

    Ti.API.info @host + options.path
    client.open method, @host + options.path
    if @token
      client.setRequestHeader "Authorization", @token
    if options.data
      client.setRequestHeader "Content-Type", "application/json"
      Ti.API.info "Sending data: " + JSON.stringify options.data
      client.send JSON.stringify options.data
    else
      do client.send


module.exports = new Api()