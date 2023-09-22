$(function () {
  $(".check_flg").on("change", function () {
    var id = $(this).attr("id");
    let partner_id = id.split("_")[2];
    let pers_type_id = $("#hid_" + id).val();
    $.ajax({
      url:
        "/super_partner_user/partner_set_permission/" +
        pers_type_id +
        "/" +
        partner_id,
      success: function (data) {
        $("#liveToast").toast("show");
        // $(this).val(data.active_flag);
      },
    });
  });
});
