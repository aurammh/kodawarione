import "../custom/range-slider";
$(function () {
  //set cover photo with color or image
  if ($("#image").data("existed") && $(".img-name").text()) {
    $(".cover-photo").show();
    $(".cover-color").hide();
    $("#student_student_pr_way").attr("checked", "checked");
  } else {
    $(".cover-photo").hide();
    $(".cover-color").show();
    $("#student_student_pr_way").removeAttr("checked");
  }
  $("#student_student_pr_way").click(function () {
    if ($("#student_student_pr_way").is(":checked")) {
      $(".cover-photo").show();
      $(".cover-color").hide();
      $("#coverImgFlag").val(true);
    } else {
      $(".cover-photo").hide();
      $(".cover-color").show();
      $("#coverImgFlag").val(false);
    }
  });

  //check specific number of checkbox and disable remaining
  if (typeof error_msg !== "undefined") {
    var modal_error_msg = error_msg;
  }
  if (typeof error_btn !== "undefined") {
    var modal_error_btn = error_btn;
  }

  $(".checkbox-click-ability:checkbox")
    .on("change", function () {
      if ($(".checkbox-click-ability:checkbox:checked").length >= 3) {
        $(".checkbox-click-ability:checkbox:not(:checked)").prop(
          "disabled",
          true
        );
        $(".cancle-close").removeAttr("disabled");
      } else if (
        $(".checkbox-click-ability:checkbox:checked").length > 0 &&
        $(".checkbox-click-ability:checkbox:checked").length < 3
      ) {
        $(".cancle-close").attr("disabled", "disabled");
        $(".checkbox-click-ability:checkbox:not(:checked)").prop(
          "disabled",
          false
        );
      } else if ($(".checkbox-click-ability:checkbox:checked").length == 0) {
        $(".checkbox-click-ability:checkbox:not(:checked)").prop(
          "disabled",
          false
        );
        $(".cancle-close").removeAttr("disabled");
      }
    })
    .trigger("change");

  $(".cancle-close").on("click", function (e) {
    if (
      $(".checkbox-click-ability:checkbox:checked").length < 3 &&
      $(".checkbox-click-ability:checkbox:checked").length > 0
    ) {
      e.preventDefault();
      Swal.fire({
        text: modal_error_msg,
        icon: "error",
        buttonsStyling: !1,
        confirmButtonText: modal_error_btn,
        customClass: {
          confirmButton: "btn fw-bold btn-light-primary",
        },
      });
    }
  });

  // checked checkbox at modal
  $(".checkbox-click-ability").on("change", bindingChkDatas).trigger("change");
});

//check ability-btn click and disable step3 save btn
// if ($(".checkbox-click-ability:checkbox:checked").length == 0) {
//   $("#step3-save").prop("disabled", true);
// }
$("#ability-btn").on("click", function () {
  $("#step3-save").prop("disabled", false);
});

function bindingChkDatas() {
  // clear old data
  if ($("div").hasClass("ability")) {
    $(".ability").remove();
  }

  //get checked data
  var checkTexts = $(".checkbox-click-ability:checked").map(function () {
    return $("label[for=" + $(this).attr("id") + "]").text();
  });

  //show and hide original text area
  if ($(".checkbox-click-ability:checked").length > 0) {
    $("#displayed_text").hide();
  } else {
    $("#displayed_text").show();
  }

  // append selected data to div
  // var div = document.createElement("div");
  // div.id = "ability";
  // div.innerHTML = checkTexts.get();
  // div.className = "ability";
  // $("#ability_text").append(div);
  $("#ability_text").empty();

  // append as title of text area one
  if (checkTexts.get(0)) {
    var div = document.createElement("div");
    div.id = $(this).attr("id");
    div.innerHTML = "①" + checkTexts.get(0);
    div.className = "ability " + this.id;
    $("#ability_one_section").show();
    $("#ability_title_one").append(div);

    var div = document.createElement("div");
    div.id = "ability";
    div.innerHTML = checkTexts.get(0);
    div.className = "ability badge badge-light-primary p-4 fs-7 me-4 mb-3";
    $("#ability_text").append(div);
  } else {
    $("#ability_one_section").hide();
  }

  // append as title of text area two
  if (checkTexts.get(1)) {
    var div = document.createElement("div");
    div.id = $(this).attr("id");
    div.innerHTML = "②" + checkTexts.get(1);
    div.className = "ability " + this.id;
    $("#ability_two_section").show();
    $("#ability_title_two").append(div);

    var div = document.createElement("div");
    div.id = "ability";
    div.innerHTML = checkTexts.get(1);
    div.className = "ability badge badge-light-primary p-4 fs-7 me-4 mb-3";
    $("#ability_text").append(div);
  } else {
    $("#ability_two_section").hide();
  }

  // append as title of text area three
  if (checkTexts.get(2)) {
    var div = document.createElement("div");
    div.id = $(this).attr("id");
    div.innerHTML = "③" + checkTexts.get(2);
    div.className = "ability " + this.id;
    $("#ability_three_section").show();
    $("#ability_title_three").append(div);

    var div = document.createElement("div");
    div.id = "ability";
    div.innerHTML = checkTexts.get(2);
    div.className = "ability badge badge-light-primary p-4 fs-7 me-4 mb-3";
    $("#ability_text").append(div);
  } else {
    $("#ability_three_section").hide();
  }

  // append as title of text area four
  if (checkTexts.get(3)) {
    var div = document.createElement("div");
    div.id = $(this).attr("id");
    div.innerHTML = "④" + checkTexts.get(3);
    div.className = "ability " + this.id;
    $("#ability_four_section").show();
    $("#ability_title_four").append(div);

    var div = document.createElement("div");
    div.id = "ability";
    div.innerHTML = checkTexts.get(3);
    div.className = "ability badge badge-light-primary p-4 fs-7 me-4 mb-3";
    $("#ability_text").append(div);
  } else {
    $("#ability_four_section").hide();
  }

  // append as title of text area five
  if (checkTexts.get(4)) {
    var div = document.createElement("div");
    div.id = $(this).attr("id");
    div.innerHTML = "⑤" + checkTexts.get(4);
    div.className = "ability " + this.id;
    $("#ability_five_section").show();
    $("#ability_title_five").append(div);

    var div = document.createElement("div");
    div.id = "ability";
    div.innerHTML = checkTexts.get(4);
    div.className = "ability badge badge-light-primary p-4 fs-7 me-4 mb-3";
    $("#ability_text").append(div);
  } else {
    $("#ability_five_section").hide();
  }

  /************************************************************************************
   * Slider
   ************************************************************************************/
  rangeSlider("slider-1", [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
  rangeSlider("slider-2", [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
  rangeSlider("slider-3", [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
  rangeSlider("slider-4", [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
  rangeSlider("slider-5", [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
  rangeSlider("slider-6", [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
}
