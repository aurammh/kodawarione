$(function () {
  $(".student-url-btn").on("click", function (e) {
    var copyText = document.getElementById("student_url");
    copyText.select();
    document.execCommand("copy");
    copyText.type = "hidden";
    copyText.type = "text";
    $(this).tooltip("show");

    // input color change
    copyText.classList.add("bg-primary");
    copyText.classList.add("text-inverse-primary");

    setTimeout(function () {
      $('[data-bs-toggle="tooltip"]').tooltip("hide");
      // input color change
      copyText.classList.remove("bg-primary");
      copyText.classList.remove("text-inverse-primary");
    }, 2000);
  });

  $(".company-url-btn").on("click", function (e) {
    var copyText = document.getElementById("company_url");
    copyText.select();
    document.execCommand("copy");
    copyText.type = "hidden";
    copyText.type = "text";
    $(this).tooltip("show");

    // input color change
    copyText.classList.add("bg-primary");
    copyText.classList.add("text-inverse-primary");

    setTimeout(function () {
      $('[data-bs-toggle="tooltip"]').tooltip("hide");
      // input color change
      copyText.classList.remove("bg-primary");
      copyText.classList.remove("text-inverse-primary");
    }, 2000);
  });
});
