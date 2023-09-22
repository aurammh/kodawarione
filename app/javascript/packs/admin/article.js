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
        '<div class="hire-btn"><input type="text" class="mb-3 form-control shadow-none errors" name="admin_article[video_link][]" id="video_link_multi_data_' +
          id +
          '"></input><span class="plus_minus_icon remove_icon" id="add_row' +
          id +
          '"><i class="fas fa-minus-circle"></i></span></div>'
      );
      $(".add_vacancy").append(
        '<div class="add_row' +
          id +
          " video_link_multi_data_" +
          id +
          ' row mr-0">' +
          '<div class="col-1 pr-0">' +
          '<i class="fas fa-check" style="color: #6c757d;"></i>' +
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
});
