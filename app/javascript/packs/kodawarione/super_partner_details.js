import "flatpickr/dist/plugins/monthSelect/style.css";

var KTApexChartsDemo = (function () {
  //student gender chart color
  var studentGenderCountLabel = studentGenderLabelList;
  var studentCountListByGenderResult = studentCountListBygenderResult;
  var genderChartColor = []; 
  for (let i = 0; i < studentGenderCountLabel.length; i++) {
    let genderColor = [
      "#2ec4b6",
      "#ff0054",
      "#fcbf49",             
     ];
    genderChartColor.push(genderColor[i]);
  }   
  //  Company employee size chart Color
  var companyEmployeeCountLabel = companyEmployeeCountLabelList;
  var companyCountListByEmployeeCountResult = companyCountByEmployeeCountResult;
  Array.prototype.max = function() {
    return Math.max.apply(null, this);
  };
  var companyCountMax = companyCountListByEmployeeCountResult.max()
  var employeeChartColor = []; 
  for (let i = 0; i < companyEmployeeCountLabel.length; i++) {
    let employeeColor = [
      "#3a0ca3",
      "#008000",
      "#072ac8",
      "#fb6107",
      "#ff0054",
      "#02c39a",
    ];
    employeeChartColor.push(employeeColor[i]);
  } 

  var _kodawariChart = function() {
    var company_employee_size = document.getElementById("company_employee_size_chart");
    var student_gender = document.getElementById("student_gender_chart");   
    drawBarChart(
      company_employee_size, 
      companyCountListByEmployeeCountResult,
      companyEmployeeCountLabel,
      employeeChartColor
    );
    barChart(
      studentCompanyCountBarChart,
    );
    drawDohnutChart(
      student_gender, 
      studentCountListByGenderResult,
      studentGenderCountLabel,
      genderChartColor
    ); 
  };

  // student geder chart and school type chart
  var drawDohnutChart = function (ctx, seriesArr, labelsArr, colorsArr){ 
    var doughnut_options = {
      series: seriesArr,
      labels: labelsArr,
      chart: {
        width: 300,
        height: 300,
        type: 'donut'
      },
      dataLabels: {
        enabled: false
      },
      legend: {
        show: false,
      },      
      colors: colorsArr, 
      plotOptions: {
        pie: {
          donut: {
            labels: {
              show: true,
              value: {
                formatter: function(val){
                  return val + " 人";
                }
              },
              total: {
                show: true,
                fontWeight: 600,
                color: '#000000',
                label: '合計',
                formatter: function (w) {
                  return w.globals.seriesTotals.reduce((a, b) => {
                    return  a + b 
                  }, 0) + " 人"
                }
              }
            }
          }
        }
      },
      responsive: [{
        breakpoint: 480,
        options: {
          chart: {
            width: 200
          },
          legend: {
            position: 'bottom'
          }
        }
      }],
      tooltip: {
        y: {
          formatter: function (val) {
            return val + "人"
          }
        }
      },
    };
    document.addEventListener("turbolinks:before-cache", function () {
      chart.destroy();
    });
    var chart = new ApexCharts(ctx, doughnut_options);
    chart.render();
  };

  // Company employee count chart    
  var drawBarChart = function (ctx, seriesArr, labelsArr, colorsArr){ 
    var column_chart_options = {
      series: [{
        name: '企業',
        data: seriesArr,
      }],
      chart: {
        type: 'bar',
        height: 350,
      },
      colors: colorsArr, 
      plotOptions: {
        bar: {
          horizontal: true,
          borderRadius: 3,
          distributed: true,
          columnWidth: '30%',
          barHeight: '30%',
          dataLabels: {
            position: 'center', // top, center, bottom
          }
        }
      },
      dataLabels: {
        enabled: true,
        formatter: function (val, opts) {
          return val + "社"
        },
      },
      xaxis: {
        categories: labelsArr,
        max: companyCountMax + 20,
        position: 'bottom',
        axisBorder: {
          show: false
        },
        axisTicks: {
          show: true
        },
        crosshairs: {
          fill: {
            type: 'gradient',
            gradient: {
              colorFrom: '#D8E3F0',
              colorTo: '#BED1E6',
              stops: [0, 100],
              opacityFrom: 0.4,
              opacityTo: 0.5,
            }
          }
        },
        tooltip: {
          enabled: true,
        }
      },
      yaxis: {
        axisBorder: {
          show: false
        },
        axisTicks: {
          show: false,
        },
        labels: {
          show: true,
        }
      },
      legend: {
        show: false,
        position: 'top',
        horizontalAlign: 'left',
        offsetX: 40
      },
      tooltip: {
        y: {
          formatter: function (val) {
            return val + "社"
          }
        }
      },
    };
    document.addEventListener("turbolinks:before-cache", function () {
      chart.destroy();
    });
    var chart = new ApexCharts(ctx, column_chart_options);
    chart.render();
  }; 
    
  // Company and student count bar chart   
  var studentCountData = studentCountListResult;
  var companyCountData = companyCountListResult;
  var dateDataForLabel = dateArrayListForLabel;
  var studentCount = studentCountData.max()
  var companyCount = companyCountData.max()
  var maxValue = Math.max(studentCount, companyCount)
  var barChart = function (){ 
    var options = {
      series: [{
      name: '学生',
      color: '#ffbe0b',
      data: studentCountData
      }, {
        name: '企業',
        color: '#0077b6',
        data: companyCountData
      }],
      labels: dateDataForLabel,
        chart: {
        type: 'bar',
        height: 300
      },
      legend: {
        show: false
      },
      plotOptions: {
        bar: {
          horizontal: false,
          columnWidth: '60%',
          endingShape: 'rounded'
        },
      },
      dataLabels: {
        enabled: false
      },
      stroke: {
        show: false,
        width: 1,
        colors: ['transparent']
      },
      yaxis: {
        max: maxValue + 20,
        tickAmount: 6,
      },
      fill: {
        opacity: 1
      },
      tooltip: {       
        custom: function({series, seriesIndex, dataPointIndex, w}) {
          var data = w.globals.initialSeries[seriesIndex].data[dataPointIndex];
          if (seriesIndex == 0){
            return '<ul class= "mt-3 me-5 ms-0">' +
            '<b>学生 :</b> ' + data + " 人" ;
          }else{
            return '<ul class= "mt-3 me-5 ms-0">' +
            '<b>企業 :</b> ' + data + " 社" ;
          }          
        }
      },
    };
    document.addEventListener("turbolinks:before-cache", function () {
      chart.destroy();
    });
    var chart = new ApexCharts(document.querySelector("#studentCompanyCountBarChart"), options);
    chart.render();
  }; 

  return {
    // public functions
    init: function () {
      _kodawariChart();
    },
  };
})();
  
// On document ready
jQuery(document).ready(function () {
    KTApexChartsDemo.init();
});