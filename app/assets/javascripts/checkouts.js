$(document).on("turbolinks:load", function(){
  $("#use_delivery_address").on("click", function(){
    var array = [];
    CollectDeliveryAddress(array);
    PasteBillingAddress(array);
  });
  
  $("#from_delivery_method").on("click", function(){
    $(".delivery_method").hide();
    $(".delivery_address").show();
    $("#to_delivery_method").show();
    $("#from_delivery_address").show();
    $(this).hide();
  });
  
  $("#to_delivery_method").on("click", function(){
    $(".delivery_method").show();
    $(".delivery_address").hide();
    $("#to_delivery_method").hide();
    $("#from_delivery_address").hide();
    $(this).hide();
    $("#from_delivery_method").show();
  });

  $("#from_delivery_address").on("click", function(){
    $(".billing_address").show();
    $(".delivery_address").hide();
    $("#use_delivery_address").show();
    $(this).hide();
    $("#to_delivery_method").hide();
    $("#to_delivery_address").show();
    $("#from_billing_address").show();
  });
  
  $("#to_delivery_address").on("click", function(){
    $(".billing_address").hide();
    $(".delivery_address").show();
    $("#use_delivery_address").hide();
    $("#submit_form").hide();
    $(this).hide();
    $("#to_delivery_method").show();
    $("#from_delivery_address").show();
    $("#from_billing_address").hide();
  });
  
  $("#from_billing_address").on("click", function(){
    $(".payment_method").show();
    $("#to_billing_address").show();
    $("#to_delivery_address").hide();
    $("#use_delivery_address").hide();
    $(".billing_address").hide();
    $("#submit_form").show();
    $(this).hide();
  });
  
  $("#to_billing_address").on("click", function(){
    $(".payment_method").hide();
    $("#submit_form").hide();
    $(this).hide();
    $("#to_delivery_address").show();
    $("#from_billing_address").show();
    $(".billing_address").show();
  });

  var handler = StripeCheckout.configure({
    key: "pk_test_GQq9bxu7aMfrR0YCsfw86ZYF",
    image: 'https://stripe.com/img/documentation/checkout/marketplace.png',
    locale: 'auto',
    token: function(token) {
      // console.log(token);
    }
  });
  
  document.getElementById('creditCardButton').addEventListener('click', function(e) {
    // Open Checkout with further options:
    handler.open({
      name: 'Stripe.com',
      // description: '2 widgets',
      // zipCode: true,
      amount: 1000
    });
    e.preventDefault();
  });
  
  window.addEventListener('popstate', function() {
    handler.close();
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