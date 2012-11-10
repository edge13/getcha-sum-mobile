formatDate = ->
  date = new Date()
  datestr = date.getMonth() + "/" + date.getDate() + "/" + date.getFullYear()
  if date.getHours() >= 12
    datestr += " " + ((if date.getHours() is 12 then date.getHours() else date.getHours() - 12)) + ":" + date.getMinutes() + " PM"
  else
    datestr += " " + date.getHours() + ":" + date.getMinutes() + " AM"
  datestr

class RefreshingTable
  constructor: (options) ->
    @table = Ti.UI.createTableView options

    border = Ti.UI.createView
      backgroundColor: "#576c89"
      height: 2
      bottom: 0

    @tableHeader = Ti.UI.createView
      backgroundColor: "#e2e7ed"
      width: 320
      height: 60

    @tableHeader.add border

    @arrow = Ti.UI.createView
      backgroundColor: "orange"
      width: 23
      height: 60
      bottom: 10
      left: 20

    @statusLabel = Ti.UI.createLabel
      text: "Pull to reload"
      left: 55
      width: 200
      bottom: 30
      height: "auto"
      color: "#576c89"
      textAlign: "center"
      font:
        fontSize: 13
        fontWeight: "bold"

      shadowColor: "#999"
      shadowOffset:
        x: 0
        y: 1

    @lastUpdatedLabel = Ti.UI.createLabel
      text: "Last Updated: " + do formatDate
      left: 55
      width: 200
      bottom: 15
      height: "auto"
      color: "#576c89"
      textAlign: "center"
      font:
        fontSize: 12

      shadowColor: "#999"
      shadowOffset:
        x: 0
        y: 1

    @actInd = Titanium.UI.createActivityIndicator
      left: 20
      bottom: 13
      width: 30
      height: 30

    @tableHeader.add @arrow
    @tableHeader.add @statusLabel
    @tableHeader.add @lastUpdatedLabel
    @tableHeader.add @actInd
    @table.headerPullView = @tableHeader


    @pulling = false
    @reloading = false

    @table.addEventListener "scroll", (e) =>
      offset = e.contentOffset.y
      if offset < -65.0 and not @pulling and not @reloading
        t = Ti.UI.create2DMatrix()
        t = t.rotate(-180)
        @pulling = true
        @arrow.animate
          transform: t
          duration: 180

        @statusLabel.text = "Release to refresh..."

      else if (offset > -65.0 and offset < 0) and @pulling and not @reloading
        @pulling = false
        t = Ti.UI.create2DMatrix()
        @arrow.animate
          transform: t
          duration: 180

        @statusLabel.text = "Pull down to refresh..."

    @table.addEventListener "dragEnd", =>
      if @pulling and not @reloading
        @reloading = true
        @pulling = false
        @arrow.hide()
        @actInd.show()
        @statusLabel.text = "Reloading..."
        @table.setContentInsets
          top: 60
        ,
          animated: true

        @table.scrollToTop -60, true
        @arrow.transform = Ti.UI.create2DMatrix()
        do @beginReloading

    @table.addEventListener "click", (e) =>
      do @onRowClicked e if @onRowClicked?


    @view = @table

  beginReloading: ->
    #override
    Ti.API.info "beginning reload"

  endReloading: =>
    Ti.API.info "ending reload"
    @table.setContentInsets({top:0},{animated:true});
    @reloading = false;
    @lastUpdatedLabel.text = "Last Updated: "+formatDate();
    @statusLabel.text = "Pull down to refresh...";
    @actInd.hide();
    @arrow.show();

  onRowClicked: (row) ->


  setData: (data) ->
    @table.data = data


module.exports = RefreshingTable


