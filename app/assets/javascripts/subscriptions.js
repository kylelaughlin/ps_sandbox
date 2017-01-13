// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.


$(document).on("turbolinks:load", function(){

  $('form').submit(function (e) {
    e.preventDefault();


    var cardOwnerName = $("#card_owner_name").val();
    var cardNumber = $("#number").val();
    var expMonth = $("#exp_month").val();
    var expYear = $("#exp_year").val();
    var cardCsc = $("#csc").val();
    var publicKey = $("#ps_public_key").val();

    payload = {
               public_api_key: publicKey,
               card_number: cardNumber,
               card_exp_month: expMonth,
               card_exp_year: expYear,
               csc: cardCsc,
               card_owner_name: cardOwnerName
              }

    $.ajax ({
      type: "GET",
      dataType: "json",
      url: "https://api.paymentspring.com/api/v1/tokens/jsonp",
      headers: {
        "Authorization": "Basic" + btoa(publicKey + ":")
      },
      data: payload,
      success: function (e) {
        sendLocalServer(e);
      }
    })

  })

})

function sendLocalServer(response) {
  var planId = $("input[type=radio]:checked").val();
  $.ajax ({
    type: "POST",
    url: "/subscriptions",
    data: {subscription: {plan_id: planId, token_id: response["id"]}}
  })
}
