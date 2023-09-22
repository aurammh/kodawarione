$(function () {
  $(".check_flg").on("change", function () {
    var id = $(this).attr("id");
    let partner_user_id = id.split("_")[2];
    let pers_type_id = $("#hid_" + id).val();
    let partner_id = $("#partner_id").val();
    let link_url =
      "/super_partner_user/partner_user_lists_permission/" +
      pers_type_id +
      "/" +
      partner_user_id +
      "/" +
      partner_id;
    $.ajax({
      url: link_url,
      success: function (data) {
        $("#liveToast").toast("show");
      },
    });
  });
});
