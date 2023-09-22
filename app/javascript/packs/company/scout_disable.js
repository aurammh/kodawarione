$(function () {
    var com_complete = $('#com_progress_complete').val();
    var com_details = $('#com_progress_details').val().match(/\d+/g);
    let progress_complete = (com_complete.toLowerCase() === 'true');  
    let modal_link = "";
    $('.scout-popup-btn').on("click", function (e) {
        if (progress_complete == false) {
            if (com_details[0] == 0) {
                modal_link = $('#temporary_registration_link').val();
            } else if (com_details[1] == 0) {
                modal_link = $('#commitment_ability_link').val();
            } else if (com_details[2] == 0) {
                modal_link = $('#basic_info_link').val();
            } else if (com_details[3] == 0) {
                modal_link = $('#question_assessment_link').val();           
            } else if (com_details[5] == 0) {
                modal_link = $('#about_us_form_link').val();
            } else {
                modal_link = $('#home_form_link').val();
            }            
            var modal_btn = $('#link_btn').val();
            var modal_error_msg = $('#com_error_msg').val();
            Swal.fire({
                text: modal_error_msg,
                icon: "warning",
                buttonsStyling: false,
                confirmButtonText: modal_btn,
                customClass: {
                    confirmButton: "btn fw-bold btn-light-primary",
                },
            }).then((result) => {
                if (result.isConfirmed) {
                    window.location = modal_link;
                }
            });
            return false;
        }
    });
});