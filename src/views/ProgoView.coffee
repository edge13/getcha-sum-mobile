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
      backgroundImage: "/background.png"
      top: 0

    @views.push @view
    @window.add @view

    do @layout


  layout: ->

  onShow: ->
    
  showModal: (view) ->
    @views.push view
    @window.add view

  popModal: =>
    return if @views.length is 1
    view = do @views.pop
    @window.remove view

  open: ->
    do @window.open

  close: ->
    do @window.close


module.exports = ProgoView

