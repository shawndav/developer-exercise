$(document).ready(function(){

  $('.info').hide();


  $(".header").on("click",function(){
    var info = $(this).next();
    $('.info').not(info).slideUp();
    info.slideToggle();
  })

});