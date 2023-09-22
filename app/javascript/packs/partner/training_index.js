import { Japanese } from "flatpickr/dist/l10n/ja";
$(function () {
  flatpickr("#a_start_date", {
    dateFormat: "Y",
    locale: Japanese,
    wrap: true,
    disableMobile: "true"
  });
  /*開催期間のカレンダー [even end date]*/
  // flatpickr("#a_end_date", {
  //   minDate: "",
  //   locale: Japanese,
  //   wrap: true,
  //   disableMobile: "true",
  //   onChange: function (selectedDates, dateStr, instance) {
  //     if (dateStr < $("#start_date").val()) {
  //       $("#start_date").val("");
  //     }
  //     flatpickr("#a_start_date", {
  //       minDate: "",
  //       maxDate: dateStr,
  //       locale: Japanese,
  //       wrap: true,
  //       disableMobile: "true",
  //     });
  //   },
  // });

  // ** begin::toast message for admin event details **

  // $("#myToast").toast("show");

  // ** end::toast message for admin event details **
});
