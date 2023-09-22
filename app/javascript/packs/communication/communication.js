$(function () {
  // show reply form
  $("#reply-form").hide();
  $(".reply-btn, .discard-btn").click(function () {
    $("#reply-form, .reply-btn").fadeToggle("fast");
  });

  $("#mail_template_id").on("change", function (e) { 
    var template_id = $(this).val();
    var title = $('#title');
    var content = $('#content');
    var chk_box = $('#save-template');
    if (template_id != "") {
      chk_box.prop('disabled', true);
      chk_box.prop('checked', false);
      chk_box.siblings().text($("#edit_template").val());
      chk_box.siblings().addClass('pe-none');
    } else {
      chk_box.siblings().text($("#new_template").val());
      title.val('');
      content.val('');
      chk_box.prop('disabled', false);
      chk_box.prop('checked', false);
      chk_box.siblings().removeClass('pe-none');
      return;
    }
    // ajax request
    $.ajax({
      url: "/communication/template_change",
      type: "GET",
      data: {
        mail_template_id: template_id
      },
      dataType: "json",
      success: (data) => {
        title.val(data.subject);
        content.val(data.content.body);

        $([title[0],content[0]]).on('keyup input paste',function(e){
          // check box disable and enable for keyup, input and paste events
          // setTimeout to get after paste value
          setTimeout(function () {
            if (title.val() != data.subject || content.val() != data.content.body) {
              chk_box.prop('disabled', false);
              chk_box.prop('checked', true);
            } else {
              chk_box.prop('disabled', true);
              chk_box.prop('checked', false);
            }
          }, 100);
        });

        $([content[0]]).on('pointerup focus',function(e){
          // rich text buttons click event after pointerup and focus events
          $('.trix-button').on('click',function(e){
            if (content.val() != data.content.body) {
              chk_box.prop('disabled', false);
              chk_box.prop('checked', true);
            } else {
              chk_box.prop('disabled', true);
              chk_box.prop('checked', false);
            }
          });
        });
      }
    });
  });
  
  /*click submit check for form filed */
  $("#btn-communicaion").on("click", function (e) {
    var err_flag = false;
    $("#communication-form *")
      .filter(":input.errors")
      .not("input[type='hidden']")
      .each(function () {
        if ($(this).val() == "") {
          err_flag = true;
          $(".error_" + $(this).attr("id")).addClass("field_with_errors");
          $(".err_" + $(this).attr("id")).removeClass("d-none");
        } else {
          $(".error_" + $(this).attr("id")).removeClass("field_with_errors");
          $(".err_" + $(this).attr("id")).addClass("d-none");
        }
    });
    $("#communication-form *")
      .filter("select.errors")
      .each(function () {
        if ($(this).val() == "") {
          err_flag = true;
          $(".error_" + $(this).attr("id")).addClass("field_with_errors");
          $(".err_" + $(this).attr("id")).removeClass("d-none");
        } else {
          $(".error_" + $(this).attr("id")).removeClass("field_with_errors");
          $(".err_" + $(this).attr("id")).addClass("d-none");
        }
    });

    if (document.querySelector("trix-editor").value == "" ) {
      err_flag = true;
      $(".error_content").addClass("field_with_errors");
      $(".err_content").removeClass("d-none");
    } else {
      $(".error_content").removeClass("field_with_errors");
      $(".err_content").addClass("d-none");
    }
    if (err_flag) {
      return false;
    } else {
      return true;
    }
  });

  /*click submit check for form filed */
  $("#btn-communicaion-list").on("click", function (e) {
    var err_flag = false;
    $("#communication-form *")
      .filter(":input.errors")
      .not("input[type='hidden']")
      .each(function () {
        console.log($(this).attr("id"));
        if ($(this).val() == "") {
          err_flag = true;
          $(".error_" + $(this).attr("id")).addClass("field_with_errors");
          $(".err_" + $(this).attr("id")).removeClass("d-none");
        } else {
          $(".error_" + $(this).attr("id")).removeClass("field_with_errors");
          $(".err_" + $(this).attr("id")).addClass("d-none");
        }
      });
    if (document.querySelector("trix-editor").value == "") {
      err_flag = true;
      $(".error_content").addClass("field_with_errors");
      $(".err_content").removeClass("d-none");
    } else {
      $(".error_content").removeClass("field_with_errors");
      $(".err_content").addClass("d-none");
    }
    if (err_flag) {
      return false;
    } else {
      return true;
    }
  });
});