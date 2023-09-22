import { Japanese } from "flatpickr/dist/l10n/ja";
$(function () {
  flatpickr("#start_time", {
    "dateFormat":"H:i", 
    "enableTime":true, 
    "allowInput":true,
    "noCalendar": true,
    onChange: function (selectedDates, dateStr, instance) {
      flatpickr("#end_time", {
        "dateFormat":"H:i", 
        "minTime": dateStr,
        "enableTime":true, 
        "allowInput":true,
        "noCalendar": true,
      })
    }
  });
  flatpickr("#end_time", {
    "dateFormat":"H:i", 
    "enableTime":true, 
    "allowInput":true,
    "noCalendar": true
  })
});
