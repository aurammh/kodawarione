import { Japanese } from "flatpickr/dist/l10n/ja";
$(function () {
  /*to get muliselect*/
  $("#event_category").select2();

  /* 開催期間のカレンダー [even start date]*/
  let event_start = flatpickr("#e_start_date", {
    minDate: "today",
    maxDate: $('#event_end_date').attr('value'),
    locale: Japanese,
    wrap: true,
    disableMobile: "true",
    allowInvalidPreload: true,
    altInput: true,
    altFormat: "Y年m月d日",
    onChange: function (selectedDates, dateStr, instance) {
      post_start.set('maxDate',dateStr); //set max post start date with event end date
      event_end.set('minDate',dateStr); //set min event end date with event start date
      apply_start.set('maxDate',dateStr); //set max apply start date with event start date
    },
  });
  /*開催期間のカレンダー [even end date]*/
  let event_end = flatpickr("#e_end_date", {
    minDate: $('#event_start_date').attr('value')? $('#event_start_date').attr('value') : "today",
    locale: Japanese,
    wrap: true,
    disableMobile: "true",
    allowInvalidPreload: true,
    altInput: true,
    altFormat: "Y年m月d日",
    onChange: function (selectedDates, dateStr, instance) {
      event_start.set('maxDate',dateStr); //set max event start date with event end date 
      post_end.set('maxDate',dateStr); //set max post end date with event end date when event is finish
      apply_end.set('maxDate',dateStr); //set max apply end date with envent end date when post end date is not selected
    },
  });

  /*掲載期間のカレンダー [post start date]*/
  let post_start = flatpickr("#p_start_date", {
    minDate: "today",
    maxDate: $("#event_start_date").attr('value'),
    locale: Japanese,
    wrap: true,
    disableMobile: "true",
    allowInvalidPreload: true,
    altInput: true,
    altFormat: "Y年m月d日",
    onChange: function (selectedDates, dateStr, instance) {
      post_end.set('minDate',dateStr); //set min post end date with post start date
      post_end.changeMonth(1); //for month list no changed
      apply_start.set('minDate',dateStr); //set min apply start date with post start date
      apply_start.changeMonth(1); //for month list no changed
      apply_end.set('minDate',dateStr); //set min apply end date with post start date when apply start is not selected
      apply_end.changeMonth(1); //for month list no changed
    },
  });

  /*掲載期間のカレンダー [post end date]*/
  let post_end = flatpickr("#p_end_date", {
    minDate: $('#post_start_date').attr('value')? $('#post_start_date').attr('value') : "today",
    maxDate: $('#event_end_date').attr('value'),
    locale: Japanese,
    wrap: true,
    disableMobile: "true",
    allowInvalidPreload: true,
    altInput: true,
    altFormat: "Y年m月d日",
    onChange: function (selectedDates, dateStr, instance) {
      apply_end.set('maxDate',dateStr); //set max apply end date with post end date
      apply_start.set('maxDate',dateStr); //set max apply start wtih post end date when post start date is no selected
      apply_start.changeMonth(1); //for month list no changed
    },
  });

  /*申込開始日のカレンダー [application start date]*/
  let apply_start = flatpickr("#application_start_date_picker", {
    minDate: $("#post_start_date").attr('value')? $('#post_start_date').attr('value') : "today",
    maxDate: $('#event_start_date').attr('value')? $('#event_start_date').attr('value') : $('#post_end_date').attr('value')? $('#post_end_date').attr('value') : "today",
    wrap: true,
    locale: Japanese,
    disableMobile: "true",
    allowInvalidPreload: true,
    altInput: true,
    altFormat: "Y年m月d日",
    onChange: function (selectedDates, dateStr, instance) {
      apply_end.set('minDate',dateStr); //set min apply end date with apply start data
      apply_end.changeMonth(1); //for month list no changed
    },
  });

  /*申込締切日のカレンダー [application deadline date]*/
  let apply_end = flatpickr("#application_deadline_picker", {
    minDate: $("#application_start_date").attr('value')? $("#application_start_date").attr('value') : $("#post_start_date").attr('value')? $("#post_start_date").attr('value') : "today",
    maxDate: $('#post_end_date').attr('value')? $('#post_end_date').attr('value') : $('#event_end_date').attr('value'),
    wrap: true,
    locale: Japanese,
    disableMobile: "true",
    allowInvalidPreload: true,
    altInput: true,
    altFormat: "Y年m月d日",
    onChange: function (selectedDates, dateStr, instance) {
      apply_start.set('maxDate',dateStr);//set max apply start date with post end date
      apply_start.changeMonth(1); //for month list no changed
    },
  });

  /*set favorite event icon for search event list*/
  $("div.favourite-event").on("click", function () {
    let event_id = this.id.split("_").pop();
    $.ajax({
      url: "/student/favourite_event/" + event_id,
      error: function (error) {},
      success: function (data) {
        if (data.favourite_flag) {
          $("#fav_" + event_id).children().addClass("text-danger").removeClass("text-secondary");
        } else {
          $("#fav_" + event_id).children().addClass("text-secondary").removeClass("text-danger");
        }
      },
    });
  });

   /*set join event for search event list*/
   $("div.join-event").on("click", function () {
    let event_id = this.id.split("_").pop();
    $.ajax({
      url: "/student/join_event/" + event_id,
      error: function (error) {},
      success: function (data) {
        if (data.join_flag) {
          $("#join_" + event_id).addClass("cursor-not-allowed").removeClass("cursor-pointer");
          $("#join_" + event_id).children().addClass("text-primary").removeClass("text-secondary");
        }
      },
    });
  });
});