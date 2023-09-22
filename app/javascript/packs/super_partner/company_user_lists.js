$(function() {
    $('.check_flg').on("change", function() {
        var id = $(this).attr("id");
        let company_user_id = id.split('_')[2];
        let pers_type_id = $("#hid_" + id).val();
        let company_id = $("#company_id").val();
        $.ajax({
            url: "/super_partner_user/company_manage/company_user_set_permission/" + pers_type_id + "/" + company_user_id + "/" + company_id,
            success: function(data) {
                $("#liveToast").toast('show');
                // $(this).val(data.active_flag);
            },
        });
    });
});