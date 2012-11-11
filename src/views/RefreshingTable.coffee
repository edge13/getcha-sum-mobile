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
    @pulling = false
    @reloading = false
    @rowHeight = options.rowHeight

    border = Ti.UI.createView
      backgroundColor: "#576c89"
      height: 2
      bottom: 0

    @tableHeader = Ti.UI.createView
      backgroundImage: "background.png"
      width: 320
      height: 60
      top: 0

    @tableHeader.add border

    @arrow = Ti.UI.createView
      backgroundColor: "transparent"
      width: 23
      height: 60
      bottom: 10
      left: 20

    @statusLabel = Ti.UI.createLabel
      text: "Pull to reload"
      left: 55
      width: 200
      bottom: 30
      height: "20dp"
      textAlign: "center"
      font:
        fontFamily: "Arvil"
        fontSize: "14sp"
      color: "#d2dd26"

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
      textAlign: "center"
      font:
        fontFamily: "Arvil"
        fontSize: "12sp"
      color: "#d2dd26"

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
    options.separatorColor = "transparent"
    @table = Ti.UI.createTableView options

    @table.headerPullView = @tableHeader

    @table.addEventListener "click", @onRowClicked

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
      Ti.API.info "clicke vent reasda"
      @onRowClicked e if @onRowClicked?

    @view = @table

  selectRow: (index) =>
    @table.fireEvent "click",
      index: index
      rowData: @rows[index]

  endReloading: =>
    super()
    @table.setContentInsets({top:0},{animated:true});

  addToView: (view) ->
    view.add @table

  setData: (data) ->
    @rows = new Array()
    for dat in data
      row = Ti.UI.createTableViewRow
        height: dat.height
      row.offer = dat.offer
      row.add dat
      @rows.push row
    @table.data = @rows

class AndroidTable extends RefreshingTable
  constructor: (options) ->
    super options

    @scrollView = Ti.UI.createScrollView
      top: options.top
      bottom: options.bottom
      showVerticalScrollIndicator: false

    @refreshView = Ti.UI.createView
      top: 0
      height: "550dp"
      backgroundColor: "transparent"

    @refreshView.add @tableHeader

    @scrollView.add @refreshView

    @view = @scrollView

  addToView: (view) ->
    view.add @scrollView

  setData: (data) ->
    return if data.length is 0
    tmpView = Ti.UI.createView
      top: 60
      height: Titanium.UI.SIZE
      width: "100%"
      layout: "vertical"

    for row in data
      row.addEventListener "click", (e) =>
        if @onRowClicked?
          @onRowClicked
            rowData: e.source
      tmpView.add row

    @scrollView.remove @rowsView if @rowsView
    @rowsView = tmpView
    @scrollView.add @rowsView

    @scrollView.scrollTo 0, 60

    @offset = 0

    @scrollView.addEventListener "scroll", (e) =>
      if e.y?
        @offset = e.y
        Ti.API.info @offset
      if @offset <= 5
        t = do Ti.UI.create2DMatrix
        t = t.rotate(-180)
        @arrow.animate
          transform: t
          duration: 180
        @statusLabel.text = "Release to Reload"
      else if @offset > 5 and @offset < 60
        t = do Ti.UI.create2DMatrix
        @arrow.animate
          transform: t
          duration: 180
        @statusLabel.text = "Pull to refresh"

    @scrollView.addEventListener "touchend", (e) =>
      Ti.API.info @reloading
      return if @reloading
      if @offset <= 5
        Ti.API.info "should begin reloading"
        @reloading = true
        @actInd.show()
        do @beginReloading
      else if @offset < 60
        @scrollView.scrollTo 0, 60
        Ti.API.info "canceling reload"

  endReloading: =>
    super()
    @scrollView.scrollTo 0,60


if Ti.Platform.osname is 'iphone'
  module.exports = IOSTable
else
  module.exports = AndroidTable


