$(function () {
    var count = $(".track").length - select2Count;
    $(".track").change(function (e) {
      update_progress();
    });
  
    // supports any number of inputs and calculates done as %
    function update_progress() {
      var length = $(".track").filter(function () {
        return this.value;
      }).length;
      var done = Math.floor(length * (100 / count));
  
      $("#percentage").empty();
      $("#percentage").append(done + "% completed");
  
      $("#org-track").empty();
      $("#org-track").append($(".track").length + " of input");
  
      $("#track").empty();
      $("#track").append(count + " of input");
      $('.perc').text(done);
      $('.meter').width(done);
      $('.progress-percent').val(done);
      console.log("FFFFFFFFFF");
      console.log( $('.progress-percent').val());
    }
  });
  