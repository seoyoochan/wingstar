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
//= require jquery_nested_form
//= require redactor-rails
//= require redactor-rails/plugins
//= require redactor-rails/langs/ko
//= require lib/jquery.easings.min
//= require lib/jquery.slimscroll.min
//= require lib/jquery.transit
//= require lib/bootstrap.min
//= require lib/icheck.min
//= require lib/modernizr.custom.min
//= require lib/jquery.nicescroll.min
//= require lib/jstz.min
//= require lib/pace.min
//= require lib/jquery.autosize.min
//= require lib/jquery.shiftenter

$(document).ready(function(){

    /********************************************************************
    * Fix for Bootstrap modal closing on clicking off & pressing ESC key
    *********************************************************************/
    $(window).keyup(function(event) {
        if(event.which === 27) {
            $(".modal").modal("hide");
        }
    });

//    $(window).mouseup(function (e)
//    {
//        var container = $(".modal");
//
//        if (!container.is(e.target) // if the target of the click isn't the container...
//            && container.has(e.target).length === 0) // ... nor a descendant of the container
//        {
//            container.modal("hide");
//        }
//    });


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
            $('#sidebar, .body, .left_column, .right_column .contents_container, .contents_right_column').css({'height':($(window).height())+'px'});
        }
    });

//    $('input').iCheck({
//        checkboxClass: 'icheckbox_flat-green',
//        radioClass: 'iradio_flat-green'
//    });


//    $('input').iCheck({
//        checkboxClass: 'icheckbox_polaris',
//        radioClass: 'iradio_polaris',
//        increaseArea: '-10%' // optional
//    });


    setInterval(function() {
        $('#main .logo, #dashboard .logo .visual').transition({
            perspective: '100px',
            rotateY: '180deg',
        }, function() { $('#main .logo, #dashboard .logo .visual').removeAttr('style'); });
    }, 3000);

    $(".tooltipOn").tooltip();


    $('body').on('show.bs.collapse', function () {
        if ($("body").hasClass("menu_active"))
        {
            $("body").removeClass("menu_active");
        }
        $("body").addClass("menu_active");
    });

    $('body').on('hide.bs.collapse', function () {
        $("body").removeClass("menu_active");
    });

    if ($('.cover .about .profile_image').hasClass('online')) {
        $('body').addClass('user_online');
    }

    $('.popWindow').popover({
        trigger: 'click',
        html: true
    });

    $('.popWindow_cover').popover({
        trigger: 'click',
        html: true,
        content: function(){
            return $('#cover_photo_menu_container').html();
        }
    });

    $('.preventLink').click(function(event){
        event.preventDefault();
    });


    // Timezone Setting
    var timeZone = jstz.determine();
    document.cookie = 'jstz_time_zone='+timeZone.name()+';';


    /*********************************************************************
    * 01. UX Approach to Sidebar
    * It shows the sidebar when the width of screen is greater than or equal to 768.
    **********************************************************************/

    $(window).resize(function(){
        if ($(window).width() >= 768) {
            $("body").addClass("menu_active");
        } else {
            $("body").removeClass("menu_active");
        }
    });

     /*********************************************************************
     * 02. UX Approach to Sidebar/Widgets
     * It shows the sidebar/widgets when mouse moves to the left/right side
     **********************************************************************/
             $('body').mousemove(function(event){
                 if ((event.pageX >= 0 && event.pageX < 3) && ($(window).width() >= 768)) {
                     $("body").addClass("menu_active");
                 }
             });

    /*********************************************************************
     * 03. UX Approach to toggle Widgets
     * It toggles the widgets when toggler is clicked.
     **********************************************************************/
    $('.widget_toggler').on('click', function(){
        if ($('body').hasClass('toggle_on')) {
            $('.contents_right_column').show();
            $('.contents_left_column').css('width', '75%');
            $('body').removeClass('toggle_on');
            $('.widget_toggler i').replaceWith('<i class="fa fa-angle-right"></i>');
        } else {
            $('.contents_right_column').hide();
            $('.contents_left_column').css('width', '100%');
            $('body').addClass('toggle_on');
            $('.widget_toggler i').replaceWith('<i class="fa fa-angle-left"></i>');
        }
    });


    $('.cover_photo_container a').on('mouseenter', function(){
        $('.cover_photo_container a span').fadeTo(5, 1);
        $(this).on('click',function(){
            $('body').addClass('cover_popover');
        });
    });

    $('.cover_photo_container a').on('mouseleave', function(){
        if ($('body').hasClass('cover_popover') && ($('.popover').length > 0)) {
        } else {
            $('.cover_photo_container a span').hide();
            $('body').removeClass('cover_popover');
        }
    });

//    $('#post-new .contents form .content').select(function(){
//        $('#editor').fadeIn(500);
//    });

    $('body').on('hidden.bs.modal', '.modal', function () {
        $(this).removeData('bs.modal');
    });

    $('#writePostModal_container .resizer').click(function(){
        if ($('body').hasClass('resizer_on')){
            $('body').removeClass('resizer_on');
        } else {
            $('body').addClass('resizer_on');
        }
    });

    $('textarea').autosize();

    $('#comment_form_container form .content').click(function(){
        $(this).css("padding","8px 10px");
    });

    $('textarea').shiftenter({
        focusClass: 'shiftenter',             /* CSS class used on focus */
        inactiveClass: 'shiftenterInactive',  /* CSS class used when no focus */
        hint: '',
        metaKey: 'shift',
        pseudoPadding: '0'
    });


});
