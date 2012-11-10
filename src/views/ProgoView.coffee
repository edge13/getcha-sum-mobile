class ProgoView
  constructor: ->
    @views = new Array()

    @window = Ti.UI.createWindow
      width: "100%"
      height: "90%"
      top: 0

    @view = Ti.UI.createView
      width: "100%"
      height: "100%"
      backgroundColor: "white"
      top: 0

    @views.push @view
    @window.add @view

    do @layout


  layout: ->


  showModal: (view) ->
    @views.push view
    @window.add view

  popModal: =>
    return if @views.length is 1
    view = do @views.pop
    @window.remove view



module.exports = ProgoView

