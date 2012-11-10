class ModalView
  constructor: (@options) ->
    @view = Ti.UI.createView
      width: "100%"
      height: "100%"
      backgroundColor: 'green'
      
    do @layout


  layout: ->


module.exports = ModalView