import monthSelectPlugin from "flatpickr/dist/plugins/monthSelect";
import "flatpickr/dist/plugins/monthSelect/style.css";
import { Japanese } from "flatpickr/dist/l10n/ja";

$(function () {
  /*initialization Data*/
  $(".email span").text($("#email").val());
  $(".email span").css("color", "#000");
  $(".email svg path").css("fill", "#f4d01f");
  /*create multi select box*/
  $("#student_student_qualification_category_id").select2();
  $("#student_student_qualification_type_id").select2();
  $("#student_student_desire_industry_type_id").select2();
  $("#student_student_desire_job_type_id").select2();
  $("#student_student_m_prefecture_id").select2();
  $("#school_type").select2();
  $("#subject_system").select2();
  $("#is_beelab_activity_participate").select2();

  /*date of birth date picker*/
  if (document.getElementById("birthday")) {
    if (document.getElementById("birthday").value) {
      flatpickr(".birthday_datepicker", {
        wrap: true,
        maxDate: "today",
        locale: Japanese,
        disableMobile: "true",
        allowInvalidPreload: true,
        altInput: true,
        altFormat: "Y年m月d日",
      });
    } else {
      flatpickr(".birthday_datepicker", {
        wrap: true,
        maxDate: "today",
        defaultDate: "1999-04-01",
        locale: Japanese,
        disableMobile: "true",
        allowInvalidPreload: true,
        altInput: true,
        altFormat: "Y年m月d日",
      });
    }
  }

  /*graduation date picker*/
  flatpickr("#graduation_date_picker", {
    wrap: true,
    // minDate: "today",
    locale: Japanese,
    disableMobile: "true",
    plugins: [
      new monthSelectPlugin({
        shorthand: true, //defaults to false
        dateFormat: "Y年m月", //defaults to "F Y"
        altFormat: "F Y", //defaults to "F Y"
        theme: "light", // defaults to "light"
      }),
    ],
  });

  /*set prefecture according region*/
  $(document).on("change", "#student_student_m_region_id", function (e) {
    var not_select = $("#not_select_label").val();
    var prefecture = $("#student_student_m_prefecture_id");
    $.ajax({
      url:
        "/student/prefecture_name/" +
        $(this).children(":selected").attr("value"),
      success: function (data) {
        var prefecture_option;
        if (data.length === 0) {
        } else {
          data.forEach(function (i) {
            prefecture_option +=
              '<option value="' + i.id + '">' + i.prefecture_name + "</option>";
          });
          prefecture.html(prefecture_option);
        }
      },
    });
  });

  /*show/hide delete file icon*/
  if ($("#upload").data("existed")) {
    $("#remove_file").show();
  } else {
    $("#remove_file").hide();
  }

  /*student PR file upload*/
  var selectedFile;
  $("#upload").on("change", function (event) {
    $("#haveFileFlag").val(false);
    if (event.target.files[0]) {
      selectedFile = event.target.files;
    } else {
      $("#upload")[0].files = selectedFile;
    }
    $(".file-chosen").text(this.files[0].name);
    $("#remove_file").show();
  });

  /*remove selected PR file*/
  $("#remove_file").on("click", function () {
    $("#upload").val("");
    $("#haveFileFlag").val(true);
    $(".file-chosen").text("ファイルを選択してください。");
    $("#remove_file").hide();
  });

  /*set favorite company icon*/
  $("#favourite_company").on("click", function () {
    $.ajax({
      url: "/student/favourite_company/" + $("#fav_company_id").val(),
      error: function (error) {},
      success: function (data) {
        // if (data.favourite_flag) {
        //   $("#favourite_company")
        //     .addClass("text-danger")
        //     .removeClass("text-muted");
        // } else {
        //   $("#favourite_company")
        //     .addClass("text-muted")
        //     .removeClass("text-danger");
        // }
        window.location.href = window.location.href;
      },
    });
  });

  $("div.favourite-company").on("click", function () {
    const c_id = this.id.split("_");
    let company_id = c_id[0];
    $.ajax({
      url: "/student/favourite_company/" + company_id,
      error: function (error) {},
      success: function (data) {
        if (data.favourite_flag) {
          $("#" + company_id + "_web")
            .children()
            .addClass("text-danger")
            .removeClass("text-secondary");
          $("#" + company_id + "_mobile")
            .children()
            .addClass("text-danger")
            .removeClass("text-secondary");
        } else {
          $("#" + company_id + "_web")
            .children()
            .addClass("text-secondary")
            .removeClass("text-danger");
          $("#" + company_id + "_mobile")
            .children()
            .addClass("text-secondary")
            .removeClass("text-danger");
        }
      },
    });
  });

  /*set favorite vacancy icon*/
  $("#favourite_vacancy").on("click", function () {
    $.ajax({
      url: "/student/favourite_vacancy/" + $("#vacancy_id").val(),
      error: function (error) {},
      success: function (data) {
        if (data.favourite_flag) {
          $("#favourite_vacancy").addClass("active").removeClass("inactive");
        } else {
          $("#favourite_vacancy").addClass("inactive").removeClass("active");
        }
        window.location.href = window.location.href;
      },
    });
  });

  $("div.favourite-vacancy").on("click", function () {
    let vacancy_id = this.id.split("_").pop();
    $.ajax({
      url: "/student/favourite_vacancy/" + vacancy_id,
      error: function (error) {},
      success: function (data) {
        if (data.favourite_flag) {
          $("#fav_" + vacancy_id)
            .children()
            .addClass("text-danger")
            .removeClass("text-secondary");
        } else {
          $("#fav_" + vacancy_id)
            .children()
            .addClass("text-secondary")
            .removeClass("text-danger");
        }
      },
    });
  });

  /*set favorite event icon*/
  $("#favourite_event").on("click", function () {
    $.ajax({
      url: "/student/favourite_event/" + $("#event_id").val(),
      error: function (error) {},
      success: function (data) {
        if (data.favourite_flag) {
          $("#favourite_event").addClass("active").removeClass("inactive");
        } else {
          $("#favourite_event").addClass("inactive").removeClass("active");
        }
        window.location.href = window.location.href;
      },
    });
  });

  /*set join event*/
  $("#join_event").on("click", function () {
    $.ajax({
      url: "/student/join_event/" + $("#event_id").val(),
      error: function (error) {},
      success: function (data) {
        if (data.join_flag) {
          $("#join_event").addClass("active").removeClass("inactive");
        } else {
          $("#join_event").addClass("inactive").removeClass("active");
        }
        window.location.href = window.location.href;
      },
    });
  });

  /*begin::set admin join event*/
  $("#join_admin_event").on("click", function () {
    $.ajax({
      url: "/student/admin_join_event/" + $("#event_id").val(),
      error: function (error) {},
      success: function (data) {
        if (data.join_flag) {
          $("#join_event").addClass("active").removeClass("inactive");
        } else {
          $("#join_event").addClass("inactive").removeClass("active");
        }
        window.location.href = window.location.href;
      },
    });
  });
  /*end::set admin join event*/
});

/*set apply vacancy icon*/
$("#apply_vacancy").on("click", function () {
  $.ajax({
    url: "/student/apply_vacancy/" + $("#vacancy_id").val(),
    error: function (error) {},
    success: function (data) {
      if (data.apply_flag) {
        $("#apply_vacancy").addClass("active").removeClass("inactive");
      } else {
        $("#apply_vacancy").addClass("inactive").removeClass("active");
      }
      window.location.href = window.location.href;
    },
  });
});

$("div.apply-vacancy").on("click", function () {
  let vacancy_id = this.id.split("_").pop();
  $.ajax({
    url: "/student/apply_vacancy/" + vacancy_id,
    error: function (error) {},
    success: function (data) {
      if (data.apply_flag) {
        $("#apply_" + vacancy_id)
          .addClass("cursor-not-allowed")
          .removeClass("cursor-pointer");
        $("#apply_" + vacancy_id)
          .children()
          .addClass("text-primary")
          .removeClass("text-secondary");
      }
    },
  });
});
