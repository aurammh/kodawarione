import "flatpickr/dist/plugins/monthSelect/style.css";
import { Japanese } from "flatpickr/dist/l10n/ja";
$(function () {
    /*date of established picker*/
  if (document.getElementById("company_established")) {
    if (document.getElementById("company_established").value) {
      flatpickr(".datepicker", {
        wrap: true,
        maxDate: "today",
        locale: Japanese,
        disableMobile: "true",
        allowInvalidPreload: true,
        altInput: true,
        altFormat: "Y年m月d日",
      });
    } else {
      flatpickr(".datepicker", {
        wrap: true,
        maxDate: "today",
        defaultDate: "2020-04-01",
        locale: Japanese,
        disableMobile: "true",
        allowInvalidPreload: true,
        altInput: true,
        altFormat: "Y年m月d日",
      });
    }
  }

  /*show/hide delete file icon*/
  if ($("#upload").data("existed")) {
    $("#remove_file").show();
  } else {
    $("#remove_file").hide();
  }

  /*student video file upload*/
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

  /*remove selected video file*/
  $("#remove_file").on("click", function () {
    $("#upload").val("");
    $("#haveFileFlag").val(true);
    $(".file-chosen").text("ファイルを選択してください。");
    $("#remove_file").hide();
  });
})