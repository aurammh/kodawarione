import monthSelectPlugin from "flatpickr/dist/plugins/monthSelect";
import "flatpickr/dist/plugins/monthSelect/style.css";
import { Japanese } from "flatpickr/dist/l10n/ja";

var KTApexChartsDemo = (function () {
  //student gender chart color
  var studentGenderCountLabel = studentGenderLabelList;
  var studentCountListByGenderResult = studentCountListBygenderResult;
  var genderChartColor = []; 
  for (let i = 0; i < studentGenderCountLabel.length; i++) {
    let genderColor = [
      "#2ec4b6",
      "#e63946",
      "#fcbf49",              
    ];
    genderChartColor.push(genderColor[i]);
  } 
  // Student region chart color
  var studentRegionLabel = studentregionLabelList;
  var studentCountListByRegionResult = studentCountListByRegion; 
  var regionChartColor = []; 
  for (let i = 0; i < studentRegionLabel.length; i++) {
    let regionColor = [
      "#c8b6ff",
      "#780000",
      "#4cc9f0",
      "#d00000",
      "#4d908e",          
      "#f15bb5",
      "#023047",
      "#bc6c25",
      "#f72585",
      "#006400",
      "#b8bedd",
      "#3c096c",
      "#61a5c2",
      "#011627",
      "#00bbf9",
      "#560bad",
      "#ff7b00",
      "#b21e35",
      "#80b918",
      "#5c677d",
      "#b100e8",
      "#263c41",
      "#2d00f7",
      "#ff4800",
      "#007f5f",
      "#1e6091",
      "#d02224",
      "#461177",
      "#757bc8",
      "#248277",          
      "#653a2a",
      "#e500a4",
      "#00b4d8",
      "#fc2f00",
      "#cf0bf1", 
      "#00008f",
      "#38b000",
      "#6d6a75",
      "#3e95cd",
      "#0022e3",
      "#ff5a00",
      "#ea1744",
      "#343a40",
      "#ff0000",
      "#5e548e",          
      "#f20089",
      "#538d22",
      "#3f288d",
      "#0077b6",   
    ];
    regionChartColor.push(regionColor[i]);
  }

  // Student School Type Chart
  var studentSchoolTypeLabel = schoolTypeLabelList;
  var studentCountListBySchoolTypeResult = studentCountListBySchoolType;
  var studentSchoolTypeChartColor = [];
  for (let i = 0; i < studentSchoolTypeLabel.length; i++) {
    let SchoolTypeColor = [ 
      "#495057",  
      "#bf0603",     
      "#03045e",
      "#55a630",
      "#dc2f02",
      "#006d77",
      "#ef233c"
    ];
    studentSchoolTypeChartColor.push(SchoolTypeColor[i]);
  } 
    
  // Company employee size chart Color
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
  // Company Region Color
  var companyRegionLabel = companyRegionLabelList;
  var companyCountListByRegionResult = companyCountListByRegion; 
  var companyRegionColor = []; 
  for (let i = 0; i < companyRegionLabel.length; i++) {
    let regionColor = [
      "#c8b6ff",
      "#780000",
      "#4cc9f0",
      "#d00000",
      "#4d908e",          
      "#f15bb5",
      "#023047",
      "#bc6c25",
      "#f72585",
      "#006400",
      "#b8bedd",
      "#3c096c",
      "#61a5c2",
      "#011627",
      "#00bbf9",
      "#560bad",
      "#ff7b00",
      "#b21e35",
      "#80b918",
      "#5c677d",
      "#b100e8",
      "#263c41",
      "#2d00f7",
      "#ff4800",
      "#007f5f",
      "#1e6091",
      "#d02224",
      "#461177",
      "#757bc8",
      "#248277",          
      "#653a2a",
      "#e500a4",
      "#00b4d8",
      "#fc2f00",
      "#cf0bf1", 
      "#00008f",
      "#38b000",
      "#6d6a75",
      "#3e95cd",
      "#0022e3",
      "#ff5a00",
      "#ea1744",
      "#343a40",
      "#ff0000",
      "#5e548e",          
      "#f20089",
      "#538d22",
      "#3f288d",
      "#0077b6",          
    ];
    companyRegionColor.push(regionColor[i]);
  }

  var _kodawariChart = function() {
    var company_region = document.getElementById("company_region_chart");
    var student_region = document.getElementById("student_region_chart"); 
    var company_employee_size = document.getElementById("company_employee_size_chart");
    var student_gender = document.getElementById("student_gender_chart");
    var student_school_type = document.getElementById("student_school_type_chart");  
    drawPieChart(
      student_gender, 
      studentCountListByGenderResult,
      studentGenderCountLabel,
      genderChartColor
    ); 
    drawStudentDoughnutChart(
      student_region,
      studentCountListByRegionResult,
      studentRegionLabel,
      regionChartColor
     );
    drawPieChart(
      student_school_type,
      studentCountListBySchoolTypeResult,
      studentSchoolTypeLabel,
      studentSchoolTypeChartColor
    );
    // Company
    drawDoughnutChart(
      company_region,
      companyCountListByRegionResult,
      companyRegionLabel,
      companyRegionColor
    );
    drawBarChart(
      company_employee_size, 
      companyCountListByEmployeeCountResult,
      companyEmployeeCountLabel,
      employeeChartColor
    );
    barChart(
      studentCompanyCountBarChart,
    );
  };
  // student geder chart and school type chart
  var drawPieChart = function (ctx, seriesArr, labelsArr, colorsArr){ 
    var doughnut_options = {
      series: seriesArr,
      labels: labelsArr,
      chart: {
        type: 'pie'
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
              show: false,
              total: {
                show: false,
                fontWeight: 600,
                color: '#000000',
                label: '合計',
                formatter: function (w) {
                  return w.globals.seriesTotals.reduce((a, b) => {
                    return  a + b 
                  }, 0)
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
  // Student Region Chart 
  var drawStudentDoughnutChart = function (ctx, seriesArr, labelsArr, colorsArr){ 
    var doughnut_options = {
      series: seriesArr,
      labels: labelsArr,
      chart: {
        type: 'donut'
      },
      dataLabels: {
        enabled: false
      },
      colors: colorsArr, 
      plotOptions: {
        pie: {
          donut: {
            labels: {
              show: true,
              value: {
                formatter: function (val) {
                  return val + " 人"
                },
              },
              total: {
                show: true,
                fontWeight: 600,
                color: '#000000',
                label: '合計',
                formatter: function (w) {
                  return w.globals.seriesTotals.reduce((a, b) => {
                    return a + b
                  }, 0).toLocaleString() + " 人"
                }
              }
            }
          }
        }
      },
      legend: {
        show: false,
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
  // Compnay Region Chart 
  var drawDoughnutChart = function (ctx, seriesArr, labelsArr, colorsArr){ 
    var doughnut_options = {
      series: seriesArr,
      labels: labelsArr,
      chart: {
        type: 'donut'
      },
      dataLabels: {
        enabled: false
      },
      colors: colorsArr, 
      plotOptions: {
        pie: {
          donut: {
            labels: {
              show: true,                
              value: {
                formatter: function (val) {
                  return val + " 社"
                },
              },
              total: {
                show: true,
                fontWeight: 600,
                color: '#000000',
                label: '合計',
                formatter: function (w) {
                  return w.globals.seriesTotals.reduce((a, b) => {return a + b}, 0).toLocaleString() + " 社";
                },
              }
            }
          }
        }
      },
      legend: {
        show: false,
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
            return val + "社"
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
      noData: {
        text: 'there is no data',
        align: 'center',
        verticalAlign: 'middle',
        offsetX: 0,
        offsetY: 0,
        style: {
          color: '#000000',
          fontSize: '14px',
          fontFamily: undefined
        }
      },
      legend: {
        show: false
      },
      plotOptions: {
        bar: {
          horizontal: true,
          borderRadius: 3,
          distributed: true,
          columnWidth: '30%',
          barHeight: '30%',
          dataLabels: {
            position: 'center', // top, center, bottom
          },  
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
  $(function() {
    /**begin::admin_search_datetime_picker */
    flatpickr("#search_date_picker", {
      wrap: true,
      locale: Japanese,
      disableMobile: "true",
      defaultDate: $("#search_date").val() === "" ? "today" : "",
      allowInvalidPreload: true,
      altInput: true,
      altFormat: "Y年m月d日",
      plugins: [
        new monthSelectPlugin({
          shorthand: true,
          dateFormat: "Y-m",
          altFormat: "Y年m月",
          theme: "light",
        }),
      ],
      onChange: function(selectedDates, dateStr, instance) {
        instance.set("defaultDate", selectedDates);
        let url = BASE_URL + "/kodawarione/dashboard/index";
        window.location.assign(url + "?searchDate=" + $("#search_date").val());
      },
    });
    /**end::admin_search_datetime_picker */
  });
  var barChart = function (){       
    var options = {
      series: [{
      name: '学生',
      color: '#ffbe0b',
      data: studentCountData,
      },{
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