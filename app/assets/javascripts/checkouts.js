$(document).on("turbolinks:load", function(){
  $("#use_delivery_address").on("click", function(){
    var array = [];
    CollectDeliveryAddress(array);
    PasteBillingAddress(array);
  });
  
  $("#pick_delivery_method").on("click", function(){
    $(".delivery_method").hide();
    $(".delivery_address").show();
    $("#back_delivery_address").show();
    $("#pick_delivery_address").show();
    $(this).hide();
  });
  
  $("#back_delivery_address").on("click", function(){
    $(".delivery_method").show();
    $(".delivery_address").hide();
    $("#back_delivery_address").hide();
    $("#pick_delivery_address").hide();
    $(this).hide();
    $("#pick_delivery_method").show();
  });

  $("#pick_delivery_address").on("click", function(){
    $(".billing_address").show();
    $(".delivery_address").hide();
    $("#use_delivery_address").show();
    $("#submit_form").show();
    $(this).hide();
    $("#back_delivery_address").hide();
    $("#back_billing_address").show();
  });
  
  $("#back_billing_address").on("click", function(){
    $(".billing_address").hide();
    $(".delivery_address").show();
    $("#use_delivery_address").hide();
    $("#submit_form").hide();
    $(this).hide();
    $("#back_delivery_address").show();
    $("#pick_delivery_address").show();
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