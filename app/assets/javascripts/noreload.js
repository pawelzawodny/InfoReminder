NoReload = {};
NoReload.Callbacks = {};

NoReload.initialize = function () {
  if (!this.initialized) {
    this.attachEventHandlers();
    this.triggerReadyEvent();
    this.initialized = true;
  }
}

NoReload.attachEventHandlers = function () {
  this.attachToLinks();
  this.attachToHistoryApi();  
}

NoReload.attachToLinks = function () {
  $('a[href!=#]', document).live('click', NoReload.Callbacks.linkClicked);
}

NoReload.attachToHistoryApi = function () {
  $(window).on('popstate', this.Callbacks.historyStateChanged);
}

NoReload.triggerReadyEvent = function () {
  $(document).trigger('noreload-url-changed');
}

NoReload.setLoadingBar = function (selector) {
  this.loadingBar = $(selector);
}

NoReload.register = function (contentSelector, urlSuffix) {
  this.content = $(contentSelector); 
  this.suffix = urlSuffix;
}

NoReload.Callbacks.linkClicked = function (e) {
  var url = $(this).attr("href");

  NoReload.changeUrl(url);

  return e.preventDefault();
}

NoReload.Callbacks.historyStateChanged = function (e) {
  var state = e.originalEvent.state;
  if (state !== null) {
    NoReload.changeUrl(state.url, true);
  }
}

NoReload.changeUrl = function (url, dontAddToHistory) {
  $(document).trigger("noreload-url-change", url);

  if(!dontAddToHistory) {
    window.history.pushState({ url: url }, 'Title', url);
  }

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

// Extending jQuery
jQuery.noreloadReady = function (readyHandler) {
    $(document).on('noreload-url-changed', function () {
      if (typeof readyHandler === 'function') {
        console.log('ready of noreload');
        readyHandler();
      }
    });
}

jQuery.fn.ready = jQuery.noreloadReady;
