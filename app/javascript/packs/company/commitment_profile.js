$(function () {
  /*student video file three upload*/
  var selectedVideoClip;
  $("#uploadVideoClip").on("change", function (event) {
    $("#haveVideoClipFlag").val(false);
    if (event.target.files[0]) {
      selectedVideoClip = event.target.files;
    } else {
      $("#uploadVideoClip")[0].files = selectedVideoClip;
    }
    $(".video-clip-choosen").text(" ");

    $("#remove-video-clip").removeClass("d-none");

    const customFile = createCustomElement(
      Math.floor(this.files[0].size / (1024 * 1024)),
      this.files[0].name
    );
    $(".video-clip-choosen").append(customFile);
  });

  /*remove selected video file three*/
  $("#remove-video-clip").on("click", function (e) {
    $("#uploadVideoClip").val("");
    $("#haveVideoClipFlag").val(true);
    $(".video-clip-choosen").text("ファイルを選択してください。");
    $("#remove-video-clip").addClass("d-none");

    e.preventDefault();
  });
});

//Dynamic HTML Element
function createCustomElement(customSize, customName) {
  const preview = document.createElement("div");
  preview.classList.add(
    "dz-preview",
    "dz-file-preview",
    "dz-error",
    "dz-complete"
  );
  const image = document.createElement("div");
  const detail = document.createElement("div");
  detail.classList.add("dz-details");
  const size = document.createElement("div");
  size.classList.add("dz-size");
  const sizeText = document.createElement("span");
  sizeText.textContent = customSize + " MB";
  const fname = document.createElement("div");
  fname.classList.add("dz-filename");
  const fileName = document.createElement("span");
  fileName.textContent = customName;
  size.appendChild(sizeText);
  fname.appendChild(fileName);
  preview.appendChild(detail);
  preview.appendChild(image);
  detail.appendChild(size);
  detail.appendChild(fname);
  return preview;
}
