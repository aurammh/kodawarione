$(function () {
  /*After click submit check for form filed [Validation] */
  $("#btn-api-access, #btn-regenerate-token").on("click", function (e) {
    var err_flag = false;
    if (e.target.id === "btn-regenerate-token") {
      $("#form_status").val("regenerate");
    }
    $("#api-access-form *")
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
    if (err_flag) {
      return false;
    } else {
      return true;
    }
  });

  $(".copy-text").on("click", function (e) {
    var copyText = document.getElementById("copy_" + e.target.id + "");
    copyText.select();
    copyText.setSelectionRange(0, 99999); /* For mobile devices */
    navigator.clipboard.writeText(copyText.value);
    $("#api_access_toast").toast("show");
  });

  /*click submit check for form empty or not */
  $(".delete_api").on("click", function (e) {
    var id_name = this.id.split("_").pop();
    $("#del_link").attr("href", "/admin/api_access_tokens/" + id_name + "");
    $("#api_delete_modal").modal("show");
  });
});
