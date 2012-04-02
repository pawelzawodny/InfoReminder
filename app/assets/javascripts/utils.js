var Utils = {};

Utils.initializeCopyableInputs = function () {
  var copyableInputs = $('input.copyable_text')

  copyableInputs.click(function () {
    this.select();
  });

  copyableInputs.attr('readonly', 'true');
}

$(document).ready(function () {
  Utils.initializeCopyableInputs();
})
