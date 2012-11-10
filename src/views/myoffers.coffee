###content
locations
  type
  price
  count
###
ProgoView = require "ProgoView"

class MyOffersView extends ProgoView
  layout: ->
    @test = Ti.UI.createLabel
      text: "what up"

    @view.add @test

module.exports = new MyOffersView()