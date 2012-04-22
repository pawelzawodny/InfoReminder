NoReload = {};
NoReload.Callbacks = {};

NoReload.initialize = function () {
  this.attachToLinks();
}

NoReload.setLoadingBar = function (selector) {
  this.loadingBar = $(selector);
}

NoReload.register = function (contentSelector, urlSuffix) {
  this.content = $(contentSelector); 
  this.suffix = urlSuffix;
}

NoReload.attachToLinks = function () {
  $('a[href!=#]', document).live('click', NoReload.Callbacks.linkClicked);
}

NoReload.Callbacks.linkClicked = function (e) {
  var url = $(this).attr("href");

  NoReload.changeUrl(url);

  return e.preventDefault();
}

NoReload.changeUrl = function (url) {
  $(document).trigger("noreload-url-change", url);

  window.history.pushState('Object', 'Title', url);
  NoReload.showLoadingBar();

  $.get(url + this.suffix, this.Callbacks.pageDownloaded);
}

NoReload.showLoadingBar = function () {
  if (typeof this.loadingBar !== 'undefined') {
    this.loadingBar.slideDown('fast');
  }
}

NoReload.hideLoadingBar = function () {
  if (typeof this.loadingBar !== 'undefined') {
    this.loadingBar.slideUp('fast');
  }
}

NoReload.Callbacks.pageDownloaded = function (page) {
  NoReload.content.html(page);
  NoReload.hideLoadingBar();

  $(document).trigger("noreload-url-changed");
}

$(document).ready(function () {
  NoReload.initialize();
})
