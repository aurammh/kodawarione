$(function () {
  $(".check_flg").on("change", function () {
    var id = $(this).attr("id");
    let company_user_id = id.split("_")[2];
    let pers_type_id = $("#hid_" + id).val();
    let company_id = $("#super_partner_id").val();
    let link_url =
      "/admin/super_partner_manage/super_partner_user_set_permission/" +
      pers_type_id +
      "/" +
      company_user_id +
      "/" +
      company_id;
    $.ajax({
      url: link_url,
      success: function (data) {
        $("#liveToast").toast("show");
      },
    });
  });
});
