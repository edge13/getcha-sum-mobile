
if Ti.Platform.osname is "iphone"
  Pusher = require "com.pusher"
  class PusherHandler
    constructor: ->
      Ti.API.info Pusher
      Pusher.setup '02db6f66ade3c8ea02f1', 
       appID: '31467'                
      secret: 'b6bfb5a2541fb7c96bce'
      reconnectAutomaticaly: false

      Pusher.connection.bind "status_change", @statusChanged

      do @connect

    statusChanged: (status) =>
      Ti.API.info "new pusher status #{status}"

    connect: =>
      Ti.API.info "attempting to connect with pusher"

      Pusher.connection.bind "connected", ->
        Ti.API.info "Pusher Connected :)"
      Pusher.connection.bind "disconnected", ->
        Ti.API.info "Pusher Disconnected"

      @channel = Pusher.subscribe "PROGO_OFFER"

      @channel.bind "CREATE", @handleEvent

      do Pusher.connect

    handleEvent: (data) =>
      Ti.API.info "new event, #{parseInt(data)}"


  module.exports = new PusherHandler()  

else
  module.exports = {}
