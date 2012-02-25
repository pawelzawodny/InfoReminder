Events = function() {
  this.initialize = function() {
    $('.datepicker').datepicker({dateFormat: 'yy-mm-dd'});
  }
}

Events.instance = new Events();
$(document).ready(Events.instance.initialize);
