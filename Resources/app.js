
try {
  tabs = require("js/TabBar");
  list = require("js/OffersList");
  listView = new list();
  tabs.add(listView.view);
  offer = require("js/OfferView");
  offerView = new offer();
  tabs.add(offerView.view);
  confirm = require("js/ConfirmationView");
  confirmView = new confirm();
  tabs.add(confirmView.view);
  tabs.open();
}
catch (exception) {
  Ti.API.info(exception)
}
