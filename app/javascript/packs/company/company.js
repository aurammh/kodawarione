$(function () {
  if ($(".chk_email").is(":checked")) {
    $(".edit_username").addClass("show");
    $(".chk_pass").prop("disabled", true);
  } else {
    $(".edit_username").removeClass("show");
  }

  if ($(".chk_pass").is(":checked")) {
    $(".edit_password").addClass("show");
    $(".chk_email").prop("disabled", true);
  } else {
    $(".edit_password").removeClass("show");
  }

  $(".chk_email").on("click", function () {
    if ($(".edit_username").hasClass("show")) {
      $(".edit_username").removeClass("show");
      $(".chk_pass").attr("disabled", false);

      // set email value default
      var email = document.getElementById("hidden_email").value;
      document.getElementById("company_user_email").value = email;
    } else {
      $(".edit_username").addClass("show");
      $(".chk_pass").attr("disabled", true);
    }
  });

  $(".chk_pass").on("click", function () {
    if ($(".edit_password").hasClass("show")) {
      $(".edit_password").removeClass("show");
      $(".chk_email").attr("disabled", false);
    } else {
      $(".edit_password").addClass("show");
      $(".chk_email").attr("disabled", true);
    }
  });

  /*Student Searching By Company*/
  /*[Ajax for location details by location_id]*/
  $("#m_region_id").on("change", function () {
    get_location_detail_data(this.value);
  });
  $("#m_region_id").trigger("change");

  /*set favourite student from company*/
  $("#favourite-student").on("click", function () {
    $.ajax({
      url: "/company/favourite_student/" + $("#student_id").val(),
      success: function (data) {
        if (data.com_std_favourite) {
          $("#favourite-student").addClass("active").removeClass("inactive");
        } else {
          $("#favourite-student").addClass("inactive").removeClass("active");
        }
      },
      error: function (error) {},
    });
  });

  /*set favorite event icon*/
  $("div.favourite-student").on("click", function () {
    let student_id = this.id;
    $.ajax({
      url: "/company/favourite_student/" + student_id,
      error: function (error) {},
      success: function (data) {
        if (data.com_std_favourite) {
          $("#" + student_id)
            .children()
            .addClass("text-danger")
            .removeClass("text-secondary");
        } else {
          $("#" + student_id)
            .children()
            .addClass("text-secondary")
            .removeClass("text-danger");
        }
      },
    });
  });

  $("div.join-admin-event").on("click", function () {
    let event_id = this.id;
    $.ajax({
      url: "/company/join_admin_event/" + event_id,
      error: function (error) {},
      success: function (data) {
        if (data.join_flag) {
          $("#" + event_id)
            .children()
            .addClass("text-primary")
            .removeClass("text-secondary");
        } else {
          $("#" + event_id)
            .children()
            .addClass("text-secondary")
            .removeClass("text-primary");
        }
      },
    });
  });
});

/*to get location detail by region for search with ajax*/
function get_location_detail_data(locationDetail_id) {
  let url = BASE_URL + "/company/getLocationDetails";
  $.ajax({
    url: url,
    data: {
      m_region_id: locationDetail_id,
    },
    dataType: "JSON",
    error: function (error) {
      $(".location-detail").empty();
    },
    success: function (data) {
      if (data.length == 0) {
        $(".locationdetail-main").hide();
      } else {
        $(".locationdetail-main").show();
        let location_detail_list = "";
        let params_locationDetails = [];
        if ($("#locationDetail_param").val() !== undefined) {
          params_locationDetails = $("#locationDetail_param").val().split(" ");
          const arrStr = params_locationDetails;
          params_locationDetails = arrStr.map((i) => Number(i));
        }
        data.forEach((element) => {
          if (params_locationDetails.length > 0) {
            if (
              params_locationDetails.find(
                (arr_value) => arr_value === element[1]
              )
            ) {
              location_detail_list += `<div class="simple-chkbox com-chk">
                            <input type="checkbox" id="locationDetail_${element[1]}" name="locationDetail_id[]" checked="checked" value="${element[1]}"> <label for="locationDetail_${element[1]}">${element[0]}</label>
                            </div>`;
            } else {
              location_detail_list += `<div class="simple-chkbox com-chk">
                            <input type="checkbox" id="locationDetail_${element[1]}" name="locationDetail_id[]" value="${element[1]}">
                            <label for="locationDetail_${element[1]}">${element[0]}</label>
                            </div>`;
            }
          } else {
            location_detail_list += `<div class="simple-chkbox com-chk"><input type="checkbox" id="locationDetail_${element[1]}" name="locationDetail_id[]" value="${element[1]}"><label for="locationDetail_${element[1]}">${element[0]}</label></div>`;
          }
        });
        $(".location-detail").empty().append(location_detail_list);
      }
    },
  });
}

$(function () {
  $("#commitment_id").select2();
});
