Events = {};
Events.EventBrowser = {};
Events.EventBrowser.Callbacks = {};
Events.EventList = {};

Events.initialize = function () {
  $('.datepicker').datepicker({dateFormat: 'yy-mm-dd'});
  this.EventBrowser.initialize(); 
  this.EventList.initialize();
}

Events.EventBrowser.initialize = function () {
  this.form = $("form#browse_events_form"); 
  this.connectEventHandlers();
}

Events.EventBrowser.connectEventHandlers = function () {
  this.form.bind('submit', this.Callbacks.onFormSubmit);
}

Events.EventBrowser.Callbacks.onFormSubmit = function (e) {
  Events.EventBrowser.loadEvents();

  return e.preventDefault();
}

Events.EventBrowser.loadEvents = function () {
  var startDate = this.getStartDate();
  var endDate = this.getEndDate();
  var groupId = this.getGroupId();

  var url = this.getBrowseUrl(startDate, endDate, groupId);
  this.fetchEvents(url, this.Callbacks.onEventsFetched);
}

Events.EventBrowser.getStartDate = function () {
  return $("input#date_start", this.form).val();
}

Events.EventBrowser.getEndDate = function () {
  return $("input#date_end", this.form).val();
}

Events.EventBrowser.getGroupId = function () {
  return $("#group_id", this.form).val(); 
}

Events.EventBrowser.getBrowseUrl = function (startDate, endDate, groupId) {
  var url;

  startDate = this.transformDate(startDate);
  endDate = this.transformDate(endDate);
  url = "/browse/";
  
  if (typeof groupId !== 'undefined' && groupId.length > 0) {
    url += "g/" + groupId + "/";
  }

  return url + startDate + "/to/" + endDate;
}

Events.EventBrowser.transformDate = function (date) {
  return date.replace(/-/g, "/");
}

Events.EventBrowser.fetchEvents = function (url, callback) {
  $.ajax(url, {
    success: callback,
    dataType: 'script'
  });
}

Events.EventBrowser.Callbacks.onEventsFetched = function (e) {
}

Events.EventList.initialize = function () {
  this.listElement = $("div#event_list");
}

Events.EventList.clear = function () {
  this.listElement.empty();
}

Events.EventList.add = function (eventHtml) {
  this.listElement.append(eventHtml);
}

Events.EventList.hide = function () {
  this.listElement.slideUp('fast');
}

Events.EventList.show = function () {
  this.listElement.slideDown('fast');
}

Events.instance = Events;
$(document).ready(function () {
  Events.initialize();
});
