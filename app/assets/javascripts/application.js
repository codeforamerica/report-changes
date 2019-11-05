// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
// = require jquery
// = require jquery_ujs
// = require activestorage
// = require devise-otp
// = require handlebars.runtime
// = require cfa_styleguide_main
// = require chardinjs
// = require tooltipster.bundle.min
// = require_tree ./templates
// = require_tree .


var noneOfTheAbove = (function() {
  var noneOf = {
    init: function () {
      var $noneCheckbox = $('#none__checkbox');
      var $otherCheckboxes = $('input[type=checkbox]').not('#none__checkbox');

      // Nothing checked?
      if ($('input:checked').length === 0) {
        $noneCheckbox.prop('checked', true);
        $noneCheckbox.parent().addClass('is-selected');
      }

      // Uncheck None if another checkbox is checked
      $otherCheckboxes.click(function(e) {
        $noneCheckbox.prop('checked', false);
        $noneCheckbox.parent().removeClass('is-selected');
      });

      // Uncheck all others if None is checked
      $noneCheckbox.click(function(e) {
        $otherCheckboxes.prop('checked', false);
        $otherCheckboxes.parent().removeClass('is-selected');
      });
    }
  };
  return {
    init: noneOf.init
  }
})();

$(document).ready(function () {
  noneOfTheAbove.init();


  $('.tooltip').tooltipster({
    theme: 'tooltipster-light',
    side: ['right', 'left', 'top', 'bottom'],
    trigger: 'click',
    maxWidth: 500
  });

  $('.tooltip').click(function(){
    if ($(this).text() == 'X') {
      $(this).text($(this).data("number"));
    } else {
      $(this).text('X');
    }
  });

  $('body').on('chardinJs:start', function(e){
    $("#annotation-btn").text("Hide annotations").removeClass('annotate-float').addClass('chardinjs-show-element');
    if ( window.location.pathname != "/" ) {
      $(".chardinjs-overlay").addClass("shrunk-overlay");
    }

    if ( window.location.pathname == "/" ) {
        $(".chardinjs-tooltiptext").addClass("white-annotate");
        $(".chardinjs-right").addClass("white-annotate-bars");
        $(".chardinjs-left").addClass("white-annotate-bars");
        $(".chardinjs-top").addClass("white-annotate-bars");
        $(".chardinjs-bottom").addClass("white-annotate-bars");
        $(".chardinjs-helper-layer").addClass("white-annotate-helper-bars");
      }

      if ( window.location.pathname == "/screens/success" ) {
        $(".chardinjs-tooltiptext").addClass("white-annotate");
      }
  })
  $('body').on('chardinJs:stop', function(e){
    $("#annotation-btn").text("Show annotations").addClass('annotate-float').removeClass('chardinjs-show-element');
  })

  if ( window.location.pathname != "/screens/what-is-your-zip-code" ) {
    $("#progress").removeAttr("data-intro").removeAttr("data-position");
    $("#progress div.tooltip").remove();
  }

  // $('body').chardinJs('start');
  // $("#annotation-btn").click(function(e){
  //   $('body').chardinJs('toggle');
  // })
})


