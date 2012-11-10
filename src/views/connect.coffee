api = require "api"

class ConnectView
  constructor: ->
    @window = Ti.UI.createWindow
      width: "100%"
      height: "100%"

  show: (options) ->
    web = Ti.UI.createWebView
      width: "100%"
      height: "100%"
      url: options.url

    web.addEventListener "beforeload", (event) =>
      Ti.API.info "before load url = " + event.url
      if event.url.substring(0, api.host.length) is api.host
        @window.remove web

    @window.add web
    do @window.open

module.exports = new ConnectView()