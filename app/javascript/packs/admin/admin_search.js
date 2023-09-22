import { Japanese } from "flatpickr/dist/l10n/ja";
$(function () {
  flatpickr("#a_start_date", {
    minDate: "",
    locale: Japanese,
    wrap: true,
    disableMobile: "true",
    allowInvalidPreload: true,
    altInput: true,
    altFormat: "Y年m月d日",
    onChange: function (selectedDates, dateStr, instance) {
      if (dateStr > $("#end_date").val()) {
        $("#end_date").val("");
      }
      flatpickr("#a_end_date", {
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
  /*開催期間のカレンダー [even end date]*/
  flatpickr("#a_end_date", {
    minDate: "",
    locale: Japanese,
    wrap: true,
    disableMobile: "true",
    allowInvalidPreload: true,
    altInput: true,
    altFormat: "Y年m月d日",
    onChange: function (selectedDates, dateStr, instance) {
      if (dateStr < $("#start_date").val()) {
        $("#start_date").val("");
      }
      flatpickr("#a_start_date", {
        minDate: "",
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
});
