// Shared Colors Definition
const primary = "#50CD89";
const success = "#1BC5BD";
const warning = "#FFA800";

// Class definition

var selfEevaluationChartData = chartSelfEevaluation;
var potentialDesireChartData = chartPotentialDesire;
var kodawariAssessmentChartData = chartKodawari;
var kodawariAssessmentLabelData = chartKodawariLabel;

var AssessmentCharts = (function () {
  var otherFunction = function () {
    /*file upload for student assessment*/
    $("#upload-assessemt").on("change", function () {
      $(".upload-assessemt-file").text(this.files[0].name);
    });

    // Active index tag check
    $('a[data-bs-toggle="tab"]').on("shown.bs.tab", function (e) {
      localStorage.setItem("lastTab", $(this).attr("href"));
    });
    var lastTab = localStorage.getItem("lastTab");

    if (lastTab) {
      $('[href="' + lastTab + '"]').tab("show");
    }
    localStorage.clear();
  };
  // Private functions
  var selfEevaluationChartFunction = function () {
    const apexChart = "#newSelfEevaluationChart";
    var chart;
    var options = {
      series: [
        {
          name: "利き脳®診断簡易版アンケート",
          data: selfEevaluationChartData,
        },
      ],
      chart: {
        height: 350,
        type: "radar",
        dropShadow: {
          enabled: true,
          blur: 1,
          left: 1,
          top: 1,
        },
      },
      stroke: {
        width: 3,
      },
      fill: {
        opacity: 0.4,
      },
      markers: {
        size: 0,
      },
      xaxis: {
        categories: ["A", "B", "C", "D"],
      },
      yaxis: {
        min: 0,
        max: 100,
      },
      colors: [primary],
      legend: {
        show: true,
        showForSingleSeries: true,
      },
    };

    document.addEventListener("turbolinks:before-cache", function () {
      chart.destroy();
    });

    chart = new ApexCharts(document.querySelector(apexChart), options);
    chart.render();
  };

  var potentialDesireChartFunction = function () {
    const apexChart = "#newPotentialDesireChart";
    var chart;
    var options = {
      series: [
        {
          name: "潜在的欲求タイプチェックアンケート入力",
          data: potentialDesireChartData,
        },
      ],
      chart: {
        height: 350,
        type: "radar",
        dropShadow: {
          enabled: true,
          blur: 1,
          left: 1,
          top: 1,
        },
      },
      stroke: {
        width: 3,
      },
      fill: {
        opacity: 0.4,
      },
      markers: {
        size: 0,
      },
      xaxis: {
        categories: ["A", "B", "C", "D", "E"],
      },
      yaxis: {
        min: 0,
        max: 10,
      },
      colors: [primary, success],
      legend: {
        show: true,
        showForSingleSeries: true,
      },
    };

    document.addEventListener("turbolinks:before-cache", function () {
      chart.destroy();
    });
    chart = new ApexCharts(document.querySelector(apexChart), options);
    chart.render();
  };

  var kodawariAssessmentChartFunction = function () {
    const apexChart = "#kodawariAssessmentChart";
    var chart;
    var options = {
      series: [
        {
          name: "こだわりタイプ",
          data: kodawariAssessmentChartData,
        },
      ],
      chart: {
        height: 350,
        type: "radar",
        dropShadow: {
          enabled: true,
          blur: 1,
          left: 1,
          top: 1,
        },
      },
      stroke: {
        width: 3,
      },
      fill: {
        opacity: 0.4,
      },
      markers: {
        size: 0,
      },
      xaxis: {
        categories: kodawariAssessmentLabelData,
      },
      yaxis: {
        min: 0,
        max: 10,
      },
      colors: [primary],
      legend: {
        show: true,
        showForSingleSeries: true,
      },
    };

    document.addEventListener("turbolinks:before-cache", function () {
      chart.destroy();
    });
    chart = new ApexCharts(document.querySelector(apexChart), options);
    chart.render();
  };

  var behavioralChartFunction = function () {
    getBehavioralChartBorder(chartThree[0], "self_expression_chart");
    getBehavioralChartBorder(chartThree[1], "self_assertion_chart");
    getBehavioralChartBorder(chartThree[2], "self_flexibility_chart");

    //* behavioral trait type chart  *// //
    function getBehavioralChartBorder(val, chartID) {
      $("#" + chartID + " .col").removeClass("graph-select");

      if (val != "null") {
        if (val >= -10 && val <= -8) {
          $("#" + chartID + " .bg-pink").addClass("graph-select");
        } else if (val >= -7 && val <= -3) {
          $("#" + chartID + " .bg-lightBlue").addClass("graph-select");
        } else if (val >= -2 && val <= 2) {
          $("#" + chartID + " .bg-green").addClass("graph-select");
        } else if (val >= 3 && val <= 7) {
          $("#" + chartID + " .bg-blue").addClass("graph-select");
        } else {
          // (+8 ～ +10)
          $("#" + chartID + " .bg-orange").addClass("graph-select");
        }
      }
    }
  };

  return {
    // public functions
    init: function () {
      otherFunction();
      selfEevaluationChartFunction();
      potentialDesireChartFunction();
      kodawariAssessmentChartFunction();
      behavioralChartFunction();
    },
  };
})();

jQuery(document).ready(function () {
  AssessmentCharts.init();
});
