$(document).ready(function(){
  $("#decrease_cart_item").on("click", function(){
    if($("#cart_item_quantity").get(0).value > 1){
      $("#cart_item_quantity").get(0).value--  
    }
  });

  $("#increase_cart_item").on("click", function(){
    if($("#cart_item_quantity").get(0).value < 1){
      $("#cart_item_quantity").get(0).value = 1  
    } else {
      $("#cart_item_quantity").get(0).value++
    }
  });  
});



