var Utils = {};

Utils.initializeCopyableInputs = function () {
  var copyableInputs = $('input.copyable_text')

  copyableInputs.click(function () {
    this.select();
  });

  copyableInputs.attr('readonly', 'true');
}

Utils.initializeTooltips = function () {
  $('[data-tooltip]').tipsy({fade: true, gravity: 'nw', title: 'data-tooltip'});
}

$(document).ready(function () {
  Utils.initializeCopyableInputs();
  Utils.initializeTooltips();
})
