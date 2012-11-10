class ProgoView
  constructor: ->
    @window = Ti.UI.createWindow
      width: "100%"
      height: "90%"
      top: 0

    @view = Ti.UI.createView
      width: "100%"
      height: "100%"
      backgroundColor: "white"
      top: 0

    @window.add @view

    do @layout


  layout: ->



module.exports = ProgoView

