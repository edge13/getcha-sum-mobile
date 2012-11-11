api = require "api"
ModalView = require "ModalView"

class ConnectView extends ModalView

  layout: ->
    web = Ti.UI.createWebView
      width: "100%"
      height: "100%"
      url: @options.url

    web.addEventListener "beforeload", (event) =>
      Ti.API.info "before load url = " + event.url
      if event.url.substring(0, api.host.length) is api.host
        Ti.API.info "shoudl close?"
        do @options.close
      if event.url is @options.cancelUrl
        do @options.close

    @view.add web

module.exports = ConnectView