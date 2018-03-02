// function decreaseQuantity(){
//   $(this).get(0).value--   
// }

// function increaseQuantity(){
//   $().get(0).value++   
// };

$("#decrease_cart_item").on("click", function(){
  console.log("dec")
  $("#cart_item_quantity").get(0).value--
});

$("#increase_cart_item").on("click", function(){
  console.log("inc")
  $("#cart_item_quantity").get(0).value++
});
