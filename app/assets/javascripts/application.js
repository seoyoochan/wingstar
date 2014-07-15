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
//= require lib/bootstrap.min
//= require lib/animate-plus.min
//= require lib/bootstrapValidator
//= require login

$(document).ready(function(){
    $(".animBox-right").mouseenter(function(){
        $(this).animate({ left: 50 }, "fast" );
    });
    $(".animBox-right").mouseleave(function(){
        $(this).animate({ left: 0 }, "fast" );
    });


    $("form#loginModal").bind("ajax:success", function(e, data, status, xhr) {
        if (data.success)
        {
            $('#loginModal_container').modal('hide');
            $('#loginModal_container .btn').hide();
        }
        else
        {
            alert('failure! from ajax:success');
        }
    });

    $("form#loginModal").bind("ajax:failure", function(e, data, status, xhr){
        if(data.errors)
        {
            alert('failure! from ajax:failure ');
        }
    });

});

