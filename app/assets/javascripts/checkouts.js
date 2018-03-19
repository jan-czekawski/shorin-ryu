$(document).on("turbolinks:load", function(){
  $("#use_delivery_address").on("click", function(){
    alert($(".delivery_address").attr("id"));  
  });
});