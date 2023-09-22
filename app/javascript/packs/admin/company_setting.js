$(function() {
    $('.check_flg').on("change", function() {
        var id = $(this).attr("id");
        let company_id = id.split('_')[2];
        let pers_type_id = $("#hid_" + id).val();
        $.ajax({
            url: "/admin/company_manage/set_permission/" + pers_type_id + "/" + company_id,
            success: function(data) {
                $("#liveToast").toast('show');
                // $(this).val(data.active_flag);
            },
        });
    });
});