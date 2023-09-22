$(function(){
    mergeFieldWithErrorsForTermsandConditions();
    mergeFieldWithErrorsForprivacyPolicy();

    // set partner_code cookie
    if (location.search.substring(1).includes("partner_code")) {
      // set cookie expires in 1 hour
      var now = new Date();
      now.setTime(now.getTime() + (1 * 3600 * 1000));
      document.cookie = location.search.substring(1)+ ';expires=' + now.toUTCString() + ';path=/';
      $('.survey-radio-group').addClass('d-none');
    } else if (document.cookie.includes("partner_code")) {
      $('.survey-radio-group').addClass('d-none');
    } else {
      $('.survey-radio-group').removeClass('d-none');
    }

    $('.survey-radio-group').on('change',function(){
      if ($('input[name=reason]:checked').attr('id') == 'other') {
        $('.other_text_field').removeClass('d-none')
      } else {
        $('.other_text_field').addClass('d-none')
      }
    });
   
    function mergeFieldWithErrorsForTermsandConditions() {
        var fields = $('.terms-and-conditions .field_with_errors');
        fields.first().append(fields.not(':first').children())
        fields.not(":first").remove();
      }

      function mergeFieldWithErrorsForprivacyPolicy(){
        var fields = $('.privacy-policy .field_with_errors');
        fields.first().append(fields.not(':first').children())
        fields.not(":first").remove();
      }
     //  to check user name lenght or not email
      // $("#username")[0].oninvalid = function () {
      //     this.setCustomValidity("半角数字の情報を入力してください。");
      //     return;
      // };

    /* password field eye icon click event [start]*/
    $("body").on("click", ".toggle-password", function () {
      $(this).children().toggleClass("d-none");
      var password = $("#password");
      password.attr("type") === "password"
      ? password.attr("type", "text")
      : password.attr("type", "password");
    });

    $("body").on("click", ".user-toggle-password", function () {
      $(this).children().toggleClass("d-none");
      var input = $("#user_password");
      if (input.attr("type") === "password") {
        input.attr("type", "text");
      } else {
        input.attr("type", "password");
      }
    });
    
    $("body").on("click", ".conf-toggle-password", function () {
      $(this).children().toggleClass("d-none");
      var input = $("#user_password_confirmation");
      if (input.attr("type") === "password") {
        input.attr("type", "text");
      } else {
        input.attr("type", "password");
      }
    });

    $("body").on("click", ".company-toggle-password", function () {
      $(this).children().toggleClass("d-none");
      var input = $("#company_user_password");
      if (input.attr("type") === "password") {
        input.attr("type", "text");
      } else {
        input.attr("type", "password");
      }
    });
    
    $("body").on("click", ".company-conf-toggle-password", function () {
      $(this).children().toggleClass("d-none");
      var input = $("#company_user_password_confirmation");
      if (input.attr("type") === "password") {
        input.attr("type", "text");
      } else {
        input.attr("type", "password");
      }
    });
    /* password field eye icon click event [end]*/
  })