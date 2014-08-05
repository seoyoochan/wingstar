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
//= require lib/jquery.transit
//= require lib/bootstrap.min
//= require lib/icheck.min
//= require lib/modernizr.custom.min

//= require lib/jquery.nicescroll.min



$(document).ready(function(){

    /********************************************************************
    * Fix for Bootstrap modal closing on clicking off & pressing ESC key
    *********************************************************************/
    $(window).keyup(function(event) {
        if(event.which === 27) {
            $(".modal").modal("hide");
        }
    });

    $(window).mouseup(function (e)
    {
        var container = $(".modal");

        if (!container.is(e.target) // if the target of the click isn't the container...
            && container.has(e.target).length === 0) // ... nor a descendant of the container
        {
            container.modal("hide");
        }
    });


    $("#notificationModal_container .modal_body, #writePostModal_container .contents").niceScroll({ autohidemode: true, cursorcolor: "#000", cursorwidth: "7px", cursorborder: "0px", cursoropacitymin: "0.3", cursoropacitymax: "0.5", touchbehavior: " true"});



    // https://github.com/Modernizr/Modernizr/issues/572
    // Similar to http://jsfiddle.net/FWeinb/etnYC/
    Modernizr.addTest('cssvhunit', function() {
        var bool;
        Modernizr.testStyles("#modernizr { height: 50vh; }", function(elem, rule) {
            var height = parseInt(window.innerHeight/2,10),
                compStyle = parseInt((window.getComputedStyle ?
                    getComputedStyle(elem, null) :
                    elem.currentStyle)["height"],10);

            bool= !!(compStyle == height);
        });
        return bool;
    });

    $(function() {
        if (!Modernizr.cssvhunit) {
            var windowH = $(window).height();
            $('.body, .left_column, .right_column .contents_container, .contents_right_column').css({'height':($(window).height())+'px'});
        }
    });

//    $('input').iCheck({
//        checkboxClass: 'icheckbox_flat-green',
//        radioClass: 'iradio_flat-green'
//    });


    $('input').iCheck({
        checkboxClass: 'icheckbox_polaris',
        radioClass: 'iradio_polaris',
        increaseArea: '-10%' // optional
    });


    setInterval(function() {
        $('#main .logo, #dashboard .header .logo').transition({
            perspective: '100px',
            rotateY: '180deg',
        }, function() { $('#main .logo, #dashboard .header .logo').removeAttr('style'); });
    }, 3000);

});
