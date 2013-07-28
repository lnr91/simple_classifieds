$(document).ready(function () {
    console.log('in the document.ready fn');
    $('.edit_user').hide();
    $('#change_password_link').bind('click',function(){
        showForm('password')
    });
    $('#change_email_link').bind('click',function(){
        showForm('email')
    });
});

var showForm = function (item) {
    $("#"+item+"_form").show();
    console.log('showaing form');
}
