IrNoReload = {};
IrNoReload.Callbacks = {};

IrNoReload.initialize = function () {
  NoReload.register('#content', "?nolayout=true");
  NoReload.setLoadingBar('#loading_bar');

  $(document).bind('noreload-url-change', this.Callbacks.urlChanged);
}

IrNoReload.Callbacks.urlChanged = function (url) {
}

$(document).ready(function () {
  IrNoReload.initialize();
});
