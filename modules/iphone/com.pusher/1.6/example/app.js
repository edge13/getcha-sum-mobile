// Initialization

// var Pusher = require('com.pusher');
var Pusher = Ti.ComPusher;

Pusher.log = function(message) {
  Ti.API.log("------------------- " + message);
}

Pusher.setup('02db6f66ade3c8ea02f1', {
  appID: '31467',                   // CHANGEME
  secret: 'b6bfb5a2541fb7c96bce',  // CHANGEME
  reconnectAutomaticaly: false
});

Pusher.connection.bind('status_change', function(status) {
  Ti.API.log("-- " + status.previous + " -- " + status.current);
});

Ti.App.addEventListener('pause', function() {
  Pusher.disconnect();
});

Ti.App.addEventListener('resume', function() {
  Pusher.connect();
});

var navigationWindow = Ti.UI.createWindow();

var window = Ti.UI.createWindow({
	backgroundColor:'white',
  title: 'Pusher'
});

var nav = Ti.UI.iPhone.createNavigationGroup({
  window: window
});
navigationWindow.add(nav);
navigationWindow.open();

// Handlers
var handleConnected = function() {
  connect_button.enabled = false;
  add_message_button.enabled = true;

  Pusher.connection.bind('connected', function() {
    Ti.API.warn("Connected :)");

    connect_button.title = 'Disconnect';
    connect_button.enabled = true;
  });

  Pusher.connection.bind('disconnected', function() {
    Ti.API.warn("Disconnected :(");
  });

  // Connect to channel
  window.channel = Pusher.subscribe('PROGO_OFFER');

  // Bind to all events on this channel
  window.channel.bind_all(handleEvent);

  // Bind to a specific event on this channel
  window.channel.bind('alert', handleAlertEvent);

  // Fire the connection
  Pusher.connect();
};

var handleDisconnected = function() {
  connect_button.title = 'Connect';
  add_message_button.enabled = false;

  if(window.channel) {
    window.channel.unbind('bind_all', handleEvent);
    window.channel.unbind('alert', handleAlertEvent);
  }

  Pusher.disconnect();
}

var handleEvent = function(name, data) {
  Ti.API.warn("New event: " + name);

  var label = Ti.UI.createLabel({
    text: JSON.stringify(data),
    top: 3,
    left: 10,
    height: '20',
    font: {fontSize: 20}
  });

  var tableViewRow = Ti.UI.createTableViewRow({});
  tableViewRow.add(label);

  tableview.appendRow(tableViewRow, {animated:true});
};

var handleAlertEvent = function(data) {
  alert(JSON.stringify(data));
}

var connect_button = Ti.UI.createButton({
  title: 'Connect'
});
connect_button.addEventListener('click', function(e) {
  if(connect_button.title == 'Connect')
    handleConnected();
  else
    handleDisconnected();
});
window.leftNavButton = connect_button;

var add_message_button = Ti.UI.createButton({
  title: 'Add',
  enabled: false
});
add_message_button.addEventListener('click', function(e) {
  var new_window = Ti.UI.createWindow({
    url: 'channel.js',
    backgroundColor: 'white',
    title: 'Send event to channel'
  });
  new_window.pusher = Pusher;
  nav.open(new_window, {animated:true});
});
window.rightNavButton = add_message_button;

var tableview = Ti.UI.createTableView({
  data: [],
  headerTitle: 'Send events to the test channel'
});
window.add(tableview);

