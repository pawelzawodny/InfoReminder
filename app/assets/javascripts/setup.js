var SetupMonitor = {};
SetupMonitor.Callbacks = {};

SetupMonitor.checkStatusWithDelay = function (delay) {
  var self = this;

  setTimeout(function () {
    self.checkStatus();
  }, 1000);
};

SetupMonitor.checkStatus = function () {
  var self = this;

  $.ajax('status/' + this.applicationId, {
    success: this.Callbacks.statusRetrieved
  });
};

SetupMonitor.Callbacks.statusRetrieved = function (data) {
  if (SetupMonitor.isReadyStatus(data['status'])) {
    SetupMonitor.downloadSetup(data);
  } else if (SetupMonitor.isErrorStatus(data['status'])) {
    SetupMonitor.showError(data);
  } else {
    SetupMonitor.checkStatusWithDelay(500);
  }
};

SetupMonitor.isReadyStatus = function (stat) {
  return stat === 'ready';
};

SetupMonitor.isErrorStatus = function (stat) {
  return stat === 'error';
};

SetupMonitor.downloadSetup = function (app) {
  var setupUrl = this.getSetupUrl(app);

  window.location = setupUrl;
  this.updateStatusPanelToReady();
};

SetupMonitor.getSetupUrl = function (app) {
  return '/' + app.id + '/info-reminder-setup.exe';
};

SetupMonitor.updateStatusPanelToReady = function () {
  var status = $('p#status_info');

  status.html('Your application is ready to download!');
  this.setup.removeClass('loading');
  this.setup.addClass('ready');
};

SetupMonitor.showError= function (app) {
  var status = $('p#status_info');

  status.html("Error occured during generating your application, please try to reload this page");
  this.setup.removeClass('loading');
  this.setup.addClass('error');
};

SetupMonitor.init = function () {
  if (!this.isDownloadPage()) {
    return;
  }

  this.setup = $('#setup');
  this.applicationId = this.setup.attr('data-application-id');
  var self = this;

  this.checkStatusWithDelay(1500);
};

SetupMonitor.isDownloadPage = function () {
  return $('#setup').length === 1;
};

$(document).ready(function () {
  SetupMonitor.init();
});
