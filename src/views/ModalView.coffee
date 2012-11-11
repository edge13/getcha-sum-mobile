class ModalView
  constructor: (@options) ->
    @view = Ti.UI.createView
      width: "100%"
      height: "100%"
      backgroundImage: "/background.png"
      
    do @layout


  layout: ->


module.exports = ModalView