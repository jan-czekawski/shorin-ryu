$(document).on("turbolinks:load", function(){
  $("#use_delivery_address").on("click", function(){
    var array = [];
    CollectDeliveryAddress(array);
    PasteBillingAddress(array);
  });
});

function CollectDeliveryAddress(arr){
  $(".delivery_address input").each(function(){
    arr.push($(this).val());
  });  
}

function PasteBillingAddress(arr){
  $(".billing_address input").each(function(){
    $(this).val(arr.shift());
  });  
}