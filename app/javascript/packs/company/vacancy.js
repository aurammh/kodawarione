import { Japanese } from "flatpickr/dist/l10n/ja";
$(function () {
  /*initialization Data*/
  $(".display_address").hide();
  //show and hide area of hiring flow at initial state
  if ($("input[name='company_vacancy[over_time]']:checked").val() == 1) {
    $(".hire_info").show();
  } else {
    $(".hire_info").hide();
  }

  /*dateime picker [vacancy start date]*/
  flatpickr(".display-from", {
    minDate: "today",
    locale: Japanese,
    wrap: true,
    disableMobile: "true",
    allowInvalidPreload: true,
    altInput: true,
    altFormat: "Y年m月d日",
    onChange: function (selectedDates, dateStr, instance) {
      if (dateStr > $("#display_to").val()) {
        $("#display_to").val("");
      }
      flatpickr(".display-to", {
        minDate: dateStr,
        locale: Japanese,
        wrap: true,
        disableMobile: "true",
        allowInvalidPreload: true,
        altInput: true,
        altFormat: "Y年m月d日",
      });
    },
  });

  /*dateime picker [vacancy start date]*/
  flatpickr(".display-to", {
    minDate: "today",
    locale: Japanese,
    wrap: true,
    disableMobile: "true",
    allowInvalidPreload: true,
    altInput: true,
    altFormat: "Y年m月d日",
    onChange: function (selectedDates, dateStr, instance) {
      if (dateStr < $("#display_from").val()) {
        $("#display_from").val("");
      }
      flatpickr(".display-from", {
        minDate: "today",
        maxDate: dateStr,
        locale: Japanese,
        wrap: true,
        disableMobile: "true",
        allowInvalidPreload: true,
        altInput: true,
        altFormat: "Y年m月d日",
      });
    },
  });

  /*show and hide area of hiring flow according having overtime or not*/
  $("input[name='company_vacancy[over_time]").on("click", function () {
    if ($("input[name='company_vacancy[over_time]']:checked").val() == 1) {
      $(".hire_info").show();
    } else {
      $(".hire_info").hide();
    }
  });

  /*add text field for hire flow*/
  var max_fields = 10; //maximum input box allow
  var x = $(".plus_minus_icon").length; //initlal text box count
  $(".plus_icon").on("click", function (e) {
    e.preventDefault();
    if (x < max_fields) {
      x++; //text box increment
      var id = ($(".plus_minus_icon").length + 1).toString();
      $("#dynamic-inputs").append(
        '<div class="d-flex hire-btn"><input type="text" class="mb-3 form-control shadow-none errors" name="company_vacancy[hiring_flow_data][]" id="company_vacancy_hiring_flow_data_' +
          id +
          '"></input><span class="plus_minus_icon remove_icon mt-3 ml-5" id="add_row' +
          id +
          '" style="font-size: 20px !important; color: #e3e2de; padding-left: 5px;"><i class="fas fa-minus-circle"></i></span></div>'
      );
      $(".add_vacancy").append(
        '<div class="add_row' +
          id +
          " company_vacancy_hiring_flow_data_" +
          id +
          ' row mr-0">' +
          '<div class="col-1 pr-0">' +
          '<i class="fas fa-check" style="color: #6c757d;"></i>' +
          "</div>" +
          '<div class="col-11 text-break">' +
          '<span style="color: #6c757d;">採用までのフローが入ります</span>' +
          "</div>" +
          "</div> "
      );
    }
  });

  /*remove text field for hire flow*/
  $("#dynamic-inputs,#original-inputs").on(
    "click",
    ".remove_icon",
    function (e) {
      //user click on remove text
      e.preventDefault();
      $(this).parent("div").remove();
      var divId = $(this).attr("id");
      $(".add_vacancy ." + divId).remove();
      x--;
    }
  );

  /*dynamically add and remove div for checked selected value*/
  $(".checkbox-click-enhancement")
    .on("change", addAndRemoveEachCheckedSelectedVal)
    .trigger("change");
  $(".checkbox-click-welfare")
    .on("change", addAndRemoveEachCheckedSelectedVal)
    .trigger("change");
  /* dynamically add and remove div for all checked condition*/
  $("#modal1CheckedAll").on("click", addAndRemoveAllCheckedSelectedVal);
  $("#modal2CheckedAll").on("click", addAndRemoveAllCheckedSelectedVal);
});

/*dynamically add and remove div for checked selected value*/
function addAndRemoveEachCheckedSelectedVal() {
  var modal1CheckedLength = $(".checkbox-click-enhancement:checked");
  var modal2CheckedLength = $(".checkbox-click-welfare:checked");

  if ($(this).attr("class") == "checkbox-click-enhancement") {
    var currentChkId = $(this).attr("id");
    // checked/unchecked all enhancement check box
    if (modal1CheckedLength.length == $("#modal1 input:checkbox").length) {
      $("#modal1CheckedAll").prop("checked", true);
    } else {
      if (modal1CheckedLength.length == 0) {
        $("#displayed_text").show();
      }
      $("#modal1CheckedAll").prop("checked", false);
    }
  } else {
    var currentChkId = $(this).attr("id");
    // checked/unchecked all welfare check box
    if (modal2CheckedLength.length == $("#modal2 input:checkbox").length) {
      $("#modal2CheckedAll").prop("checked", true);
    } else {
      if (modal2CheckedLength.length == 0) {
        $("#displayed_text").show();
      }
      $("#modal2CheckedAll").prop("checked", false);
    }
  }
  var local_detail = $("#welfare");
  //show and hide original text area
  if (modal1CheckedLength.length == 0 && modal2CheckedLength.length == 0) {
    $("#displayed_text").show();
  } else {
    $("#displayed_text").hide();
  }

  if ($(this).prop("checked")) {
    var div = document.createElement("div");
    div.id = this.id;
    div.innerHTML = $("label[for=" + currentChkId + "]").text();
    div.className =
      "welfare " +
      this.id +
      " label label-pill label-inline font-weight-bold label-md mr-2 mb-2";
    local_detail.append(div);
  } else {
    $("." + $(this).attr("id")).remove();
  }
}

/*dynamically add and remove div for all checked condition*/
function addAndRemoveAllCheckedSelectedVal() {
  //filter duplicate data
  var modal1InitLength = $(".checkbox-click-enhancement:checked");
  var modal2InitLength = $(".checkbox-click-welfare:checked");
  if (
    (modal1InitLength.length >= 1 && modal1InitLength.length < 5) ||
    (modal2InitLength.length >= 1 && modal2InitLength < 61)
  ) {
    $("#welfare").empty();
  }
  var id_val;
  if ($(this).attr("id") == "modal1CheckedAll") {
    id_val = "modal1";
  } else {
    id_val = "modal2";
  }
  $("#" + id_val + " input[type=checkbox]").prop(
    "checked",
    $(this).prop("checked")
  );
  $("#" + id_val + " input[type=checkbox]").each(function () {
    var currentChkId = $(this).attr("id");
    var local_detail = $("#welfare");
    //show and hide original text area
    var modal1CheckedLength = $(".checkbox-click-enhancement:checked");
    var modal2CheckedLength = $(".checkbox-click-welfare:checked");
    if (modal1CheckedLength.length == 0 && modal2CheckedLength.length == 0) {
      $("#displayed_text").show();
    } else {
      $("#displayed_text").hide();
    }

    if ($(this).prop("checked")) {
      var div = document.createElement("div");
      div.id = this.id;
      div.innerHTML = $("label[for=" + currentChkId + "]").text();
      div.className =
        "welfare " +
        this.id +
        " label label-pill label-inline font-weight-bold label-md mr-2 mb-2";
      local_detail.append(div);
    } else {
      $("." + this.id).remove();
    }
  });
}
