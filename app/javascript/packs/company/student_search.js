var KTApexChartsDemo = (function () {
  const primary = "#50CD89";
  const success = "#1BC5BD";
  const warning = "#FFA800";
  // Private functions
  var kodawariAssessmentChart = chartCommitment;
  var kodawariAssessmentLabel = chartLabel;
  var _kodawariChart = function () {
    var chart;
    const apexChart = "#kodawariAssessmentChart";
    var options = {
      series: [
        {
          name: "こだわり属性",
          data: kodawariAssessmentChart,
        },
      ],
      chart: {
        height: 250,
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
        categories: kodawariAssessmentLabel,
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

  return {
    // public functions
    init: function () {
      _kodawariChart();
    },
  };
})();

jQuery(document).ready(function () {
  KTApexChartsDemo.init();
});