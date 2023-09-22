import Rails from "@rails/ujs";
import Turbolinks from "turbolinks";
import * as ActiveStorage from "@rails/activestorage";
import "channels";

Rails.start();
Turbolinks.start();
ActiveStorage.start();

/*config jquery from node_module*/
var jQuery = require("jquery");
global.$ = global.jQuery = jQuery;
window.$ = window.jQuery = jQuery;

/*config bootstrap from node_module*/
require("popper.js");
require("bootstrap");

/*config fontawesome from node_module*/
import "@fortawesome/fontawesome-free/js/all";
/*config flatpickr (datetime picker) from node_module*/
import flatpickr from "flatpickr";
import "flatpickr/dist/flatpickr.min.css";
import "flatpickr/dist/plugins/monthSelect/style.css";

/*config chart from node_module*/
import Chart from "chart.js";
import "jquery-ui/themes/base/all.css";
/*config croppie image crop from node_module*/
require("croppie");
import "croppie/croppie.css";

import "react-quill/dist/quill.snow.css";
import "react-circular-progressbar/dist/styles.css";

require("trix");
require("@rails/actiontext");
require("packs/action-text-toolbar");
import "select2";

import "video.js/dist/video-js.css";
require("video.js");

require("./theme/theme");

$(document).on("turbolinks:before-cache", function () {
  // this approach corrects the select 2 to be duplicated when clicking the back button.
  $('[data-control="select2"]').select2("destroy");
  flatpickr(".datepicker");
});

document.addEventListener("turbolinks:load", function () {
  /*inputs autocomplete off*/
  $("form").attr("autocomplete", "off");
  $(document).on("focus", "input.select2-search__field", function () {
    $("input.select2-search__field").attr("autocomplete", "new-password");
  });
});
