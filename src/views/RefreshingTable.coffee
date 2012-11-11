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
    @rowHeight = options.rowHeight

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

  beginReloading: ->
    #override
    Ti.API.info "beginning reload"

  endReloading: =>
    Ti.API.info "ending reload"
    @reloading = false;
    @lastUpdatedLabel.text = "Last Updated: "+formatDate();
    @statusLabel.text = "Pull down to refresh...";
    @actInd.hide();
    @arrow.show();

  onRowClicked: (row) ->

class IOSTable extends RefreshingTable
  constructor: (options) ->
    super options
    @table = Ti.UI.createTableView options

    @table.headerPullView = @tableHeader

    @table.addEventListener "click", (e) =>
      do @onRowClicked e if @onRowClicked?

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

    @view = @table

  endReloading: =>
    super()
    @table.setContentInsets({top:0},{animated:true});


  setData: (data) ->
    rows = new Array()
    for dat in data
      row = Ti.UI.createTableViewRow
        height: dat.height
      row.add dat
      rows.push row
    @table.data = rows

class AndroidTable extends RefreshingTable
  constructor: (options) ->
    super options

    @scrollView = TI.UI.createScrollView
      contentHeight: "auto"
      layout: "vertical"
      showVerticalScrollIndicator: false

    @scrollView.add @tableHeader
    @scrollView.scrollTo 0, 60

    @view = @scrollView
  setData: (data) ->
    tmpView = Ti.UI.createView
      height: Titanium.UI.SIZE
      width: "100%"
      layout: "vertical"

    for row in data
      tmpView.add row

    @scrollView.remove @rowsView if @rowsView
    @rowsView = tmpView
    @scrollView.add @rowsView

    @scrollView.scrollTo 0, 60

    @offset = 0

    @scrollView.addEventListener "scroll", (e) =>
      if e.y?
        @offset = e.y
      if @offset <= 5
        t = do Ti.UI.create2DMatrix
        t = t.rotate(-180)
        @arrow.animate
          transform: t
          duration: 180
        @statusLabel.text = "Release to Reload"
      else if @offset > 5 and @offset < 60
        t = do Ti.UI.create2DMatrix
        arrow.animate
          transform: t
          duration: 180
        statusLabel.text = "Pull to refresh"

    @scrollView.addEventListener "touchend", (e) =>
      return unless @reloading
      if @offset <= 5
        @reloading = true
        do @beginReloading
      else if @offset < 60
        @scrollView.scrollTo 0, 60

  endReloading: =>
    super()
    @scrollView.scrollTo 0,60


if Ti.Platform.osname is 'iphone'
  module.exports = IOSTable
else
  module.exports = AndroidTable


