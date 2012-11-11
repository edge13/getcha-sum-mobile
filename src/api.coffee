Global = require "Global"

class Api
  constructor: ->
    @host = "http://progoserver.appspot.com/"
    @token = undefined
    @dwollaId = "ApS2lLgIfKNXE4BbkuMS3rSs40XyEXvFqlc72nqJ9kTm7Tmrm6"
    @singlyId = "54e441cddf0c4c2cf1bc54de317913df"

  buildDwollaUrl: ->
    "https://www.dwolla.com/oauth/v2/authenticate?client_id=" + @dwollaId + "&response_type=code&redirect_uri=" + @host + "callbacks/dwolla/" + @token + "&scope=Send|Transactions|Balance|Request|AccountInfoFull"

  buildSinglyUrlForService: (service) ->
    if Global.me? and Global.me.singlyAccessToken?
      "https://api.singly.com/oauth/authenticate?client_id=" + @singlyId + "&access_token=#{Global.me.singlyAccessToken}" + "&redirect_uri=" + @host + "callbacks/singly/" + @token + "&service=#{service}"
    else
      "https://api.singly.com/oauth/authenticate?client_id=" + @singlyId + "&redirect_uri=" + @host + "callbacks/singly/" + @token + "&service=#{service}"

  login: (options) ->
    options.path = "users/login"
    @post options

  getMe: (options) ->
    options.path = "users/me"
    @get options

  acceptOffer: (options) ->
    options.path = "/offers/" + options.id + "/accept"
    @post options

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
        if client.responseText? and client.responseText.length > 0
          alert client.responseText
        else
          alert "An unexpected error occured"
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