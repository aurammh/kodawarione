import "select2";
import "flatpickr/dist/flatpickr.min.css";
import "flatpickr/dist/plugins/monthSelect/style.css";
import "toastr/build/toastr.min.css";

// Apexcharts - mBdern charting library that helps developers to create beautiful and interactive visualizations for web pages: https://apexcharts.com/
window.ApexCharts = require("apexcharts/dist/apexcharts.min.js");

window.bootstrap = require("bootstrap");
window.Popper = require("@popperjs/core");
window.countUp = require("countup.js/dist/countUp.withPolyfill.min.js");
window.KTUtil = require("./components/util.js");
window.KTBlockUI = require("./components/blockui.js");
window.KTCookie = require("./components/cookie.js");
window.KTDialer = require("./components/dialer.js");
window.KTDrawer = require("./components/drawer.js");
window.KTEventHandler = require("./components/event-handler.js");
window.KTFeedback = require("./components/feedback.js");
window.KTImageInput = require("./components/image-input.js");
window.KTMenu = require("./components/menu.js");
window.KTPasswordMeter = require("./components/password-meter.js");
window.KTScroll = require("./components/scroll.js");
window.KTScrolltop = require("./components/scrolltop.js");
window.KTSearch = require("./components/search.js");
window.KTStepper = require("./components/stepper.js");
window.KTSticky = require("./components/sticky.js");
window.KTSwapper = require("./components/swapper.js");
window.KTToggle = require("./components/toggle.js");
window.KTLandingPage = require("./landing.js");
window.KTWidgets = require("./components/widgets.js");
window.KTProjectOverview = require("./components/project.js");

// Layout base js
window.KTApp = require("./layout/app.js");
window.KTLayoutExplore = require("./layout/explore.js");
window.KTLayoutSearch = require("./layout/search.js");
window.KTLayoutToolbar = require("./layout/toolbar.js");
window.SmoothScroll = require("smooth-scroll");
window.Swal = require("sweetalert2");
window.toastr = require("toastr");
