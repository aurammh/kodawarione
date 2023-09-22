"use strict";

// Class definition
var KTWidgets = (function () {
  // Statistics widgets

  var initMixedWidget13 = function () {
    var height;
    var charts = document.querySelectorAll(".mixed-widget-13-chart");

    [].slice.call(charts).map(function (element) {
      height = parseInt(KTUtil.css(element, "height"));

      if (!element) {
        return;
      }

      var labelColor = KTUtil.getCssVariableValue("--bs-" + "gray-800");
      var strokeColor = KTUtil.getCssVariableValue("--bs-" + "gray-300");

      var options = {
        series: [
          {
            name: "Net Profit",
            data: [15, 25, 15, 40, 20, 50],
          },
        ],
        grid: {
          show: false,
          padding: {
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
          },
        },
        chart: {
          fontFamily: "inherit",
          type: "area",
          height: height,
          toolbar: {
            show: false,
          },
          zoom: {
            enabled: false,
          },
          sparkline: {
            enabled: true,
          },
        },
        plotOptions: {},
        legend: {
          show: false,
        },
        dataLabels: {
          enabled: false,
        },
        fill: {
          type: "gradient",
          gradient: {
            opacityFrom: 0.4,
            opacityTo: 0,
            stops: [20, 120, 120, 120],
          },
        },
        stroke: {
          curve: "smooth",
          show: true,
          width: 3,
          colors: ["#FFFFFF"],
        },
        xaxis: {
          categories: ["Feb", "Mar", "Apr", "May", "Jun", "Jul"],
          axisBorder: {
            show: false,
          },
          axisTicks: {
            show: false,
          },
          labels: {
            show: false,
            style: {
              colors: labelColor,
              fontSize: "12px",
            },
          },
          crosshairs: {
            show: false,
            position: "front",
            stroke: {
              color: strokeColor,
              width: 1,
              dashArray: 3,
            },
          },
          tooltip: {
            enabled: false,
            formatter: undefined,
            offsetY: 0,
            style: {
              fontSize: "12px",
            },
          },
        },
        yaxis: {
          min: 0,
          max: 60,
          labels: {
            show: false,
            style: {
              colors: labelColor,
              fontSize: "12px",
            },
          },
        },
        states: {
          normal: {
            filter: {
              type: "none",
              value: 0,
            },
          },
          hover: {
            filter: {
              type: "none",
              value: 0,
            },
          },
          active: {
            allowMultipleDataPointsSelection: false,
            filter: {
              type: "none",
              value: 0,
            },
          },
        },
        tooltip: {
          enabled: false,
          style: {
            fontSize: "12px",
          },
          y: {
            formatter: function (val) {
              return "$" + val + " thousands";
            },
          },
        },
        colors: ["#ffffff"],
        markers: {
          colors: [labelColor],
          strokeColor: [strokeColor],
          strokeWidth: 3,
        },
      };
      document.addEventListener("turbolinks:before-cache", function () {
        chart.destroy();
      });
      var chart = new ApexCharts(element, options);
      chart.render();
    });
  };

  var initMixedWidget14 = function () {
    var charts = document.querySelectorAll(".mixed-widget-14-chart");
    var options;
    var chart;
    var height;

    [].slice.call(charts).map(function (element) {
      height = parseInt(KTUtil.css(element, "height"));
      var labelColor = KTUtil.getCssVariableValue("--bs-" + "gray-800");

      options = {
        series: [
          {
            name: "Inflation",
            data: [
              1, 2.1, 1, 2.1, 4.1, 6.1, 4.1, 4.1, 2.1, 4.1, 2.1, 3.1, 1, 1, 2.1,
            ],
          },
        ],
        chart: {
          fontFamily: "inherit",
          height: height,
          type: "bar",
          toolbar: {
            show: false,
          },
        },
        grid: {
          show: false,
          padding: {
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
          },
        },
        colors: ["#ffffff"],
        plotOptions: {
          bar: {
            borderRadius: 2.5,
            dataLabels: {
              position: "top", // top, center, bottom
            },
            columnWidth: "20%",
          },
        },
        dataLabels: {
          enabled: false,
          formatter: function (val) {
            return val + "%";
          },
          offsetY: -20,
          style: {
            fontSize: "12px",
            colors: ["#304758"],
          },
        },
        xaxis: {
          labels: {
            show: false,
          },
          categories: [
            "Jan",
            "Feb",
            "Mar",
            "Apr",
            "May",
            "Jun",
            "Jul",
            "Aug",
            "Sep",
            "Oct",
            "Nov",
            "Dec",
            "Jan",
            "Feb",
            "Mar",
          ],
          position: "top",
          axisBorder: {
            show: false,
          },
          axisTicks: {
            show: false,
          },
          crosshairs: {
            show: false,
          },
          tooltip: {
            enabled: false,
          },
        },
        yaxis: {
          show: false,
          axisBorder: {
            show: false,
          },
          axisTicks: {
            show: false,
            background: labelColor,
          },
          labels: {
            show: false,
            formatter: function (val) {
              return val + "%";
            },
          },
          tooltip: {
            enabled: false,
          },
        },
        tooltip: {
          enabled: false,
          style: {
            fontSize: "12px",
          },
          y: {
            formatter: function (val) {
              return "$" + val + " thousands";
            },
          },
        },
      };
      document.addEventListener("turbolinks:before-cache", function () {
        chart.destroy();
      });
      chart = new ApexCharts(element, options);
      chart.render();
    });
  };

  // Public methods
  return {
    init: function () {
      initMixedWidget13();
      initMixedWidget14();
    },
  };
})();

// Webpack support
if (typeof module !== "undefined" && typeof module.exports !== "undefined") {
  module.exports = KTWidgets;
}
// On document ready
if (document.readyState === "loading") {
  document.addEventListener("turbolinks:load", function () {
    KTWidgets.init();
  });
} else {
  KTWidgets.init();
}
