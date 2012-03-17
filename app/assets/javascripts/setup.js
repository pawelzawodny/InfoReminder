var SetupMonitor = function () { }

SetupMonitor.prototype.checkStatus = function () {
  var self = this;
  $.ajax('status/' + this.applicationId, {
    success: function(app) {
      var status = $('p#status_info');

      if (app.status == 'ready') {
        window.location = '/' + app.id + '/info-reminder-setup.exe';
        status.html('Your application is ready to download!');
        self.setup.removeClass('loading');
        self.setup.addClass('ready');
      } 
      else {
        setTimeout(function () {
          self.checkStatus();
        }, 1000);
      }
    }
  });
};

SetupMonitor.prototype.init = function () {
  this.setup = $('#setup');
  this.applicationId = this.setup.attr('data-application-id');
  var self = this;

  setTimeout(function () {
    self.checkStatus();
  }, 1000);
};

$(document).ready(function () {
  SetupMonitorInstance = new SetupMonitor();
  SetupMonitorInstance.init();
});
