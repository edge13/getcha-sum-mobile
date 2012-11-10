TabBar = require "TabBar"


class ProgoView
  constructor: ->
    @view = Ti.UI.createView
      width: "100%"
      height: "90%"
      top: 0

    do @layout


  layout: ->



module.exports = ProgoView

