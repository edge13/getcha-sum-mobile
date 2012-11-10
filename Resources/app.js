
try {
  login = require("js/login");
  login.show();
}
catch (exception) {
  Ti.API.info(exception)
}
