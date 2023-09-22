$(function () {
  /*add text field for hire flow*/
  var max_fields = 10; //maximum input box allow
  var x = $(".plus_minus_icon").length; //initlal text box count
  $(".plus_icon").on("click", function (e) {
    e.preventDefault();
    if (x < max_fields) {
      x++; //text box increment
      var id = ($(".plus_minus_icon").length + 1).toString();
      $("#dynamic-inputs").append(
        '<div class="col-12 col-sm-12 offset-md-5 col-md-6 offset-lg-5 col-lg-5 offset-xl-5 col-xl-5 hire-btn mb-5"><input type="text" class="form-control form-control-solid" name="partner_article[video_link][]" id="video_link_multi_data_' +
          id +
          '"></input><span class="plus_minus_icon remove_icon" id="add_row' +
          id +
          '"><i class="fas fa-minus-circle"></i></span></div>'
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
});
