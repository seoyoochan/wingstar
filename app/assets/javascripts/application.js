// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require lib/jquery.easings.min
//= require lib/jquery.slimscroll.min
//= require lib/jquery.fullPage.min
//= require lib/jquery.transit
//= require lib/bootstrap.min
//= require lib/progression.min
//= require lib/icheck.min
//= require lib/modernizr.custom.min

$(document).ready(function(){


//    $('input').iCheck({
//        checkboxClass: 'icheckbox_flat-green',
//        radioClass: 'iradio_flat-green'
//    });


    $('input').iCheck({
        checkboxClass: 'icheckbox_polaris',
        radioClass: 'iradio_polaris',
        increaseArea: '-10%' // optional
    });

    $('#fullpage').fullpage();


    setInterval(function() {
        $('#fullpage #main .logo').transition({
            perspective: '100px',
            rotateY: '180deg',
        }, function() { $('#fullpage #main .logo').removeAttr('style'); });
    }, 5000);

    $("#loginForm").progression({
        tooltipWidth: '200',
        tooltipPosition: 'right',
        tooltipOffset: '50',
        showProgressBar: true,
        showHelper: true,
        tooltipFontSize: '14',
        tooltipFontColor: 'fff',
        progressBarBackground: 'fff',
        progressBarColor: '6EA5E1',
        tooltipBackgroundColor: 'a2cbfa',
        tooltipPadding: '10',
        tooltipAnimate: true
    });

});
