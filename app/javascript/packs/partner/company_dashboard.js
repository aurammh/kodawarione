import monthSelectPlugin from "flatpickr/dist/plugins/monthSelect";
import "flatpickr/dist/plugins/monthSelect/style.css";
import { Japanese } from "flatpickr/dist/l10n/ja";


var companyCountData = companyCountListResult;
var dateDataForLabel = dateArrayListForLabel;
var maxValueForStep = maxValueInArray;
var stepSize = calulationStepSize(maxValueForStep, 5, 5);
var regionLabel = regionLabelList;
var companyCountListByRegionResult = companyCountListByRegion;
var employeeCountLabel = targetPersonLabelList;
var companyCountListByEmployeeCountResult = companyCountListByTargetPerson;
var planTypeLabel = planTypeLabelList;
var companyCountListByPlanTypeResult = companyCountByPlanTypeResult;

var regionChartColor = [];
var employeeCountColor = [];
var planTypeChartColor = [];

for (let i = 0; i < regionLabel.length; i++) {
    let regionColor = [
        "#3cba9f",
        "#3e95cd",
        "#8e5ea2",
        "#f6c23e",
        "#f680ff",
        "#90b238",
        "#a47146",
        "#64608a",
        "#f0addc",
        "#e7ce74",
        "#efa78f",
        "#aff4b7",
        "#7edced",
        "#de7d7d",
    ];
    regionChartColor.push(regionColor[i]);
}

for (let i = 0; i < employeeCountLabel.length; i++) {
    let employeeColor = [
        "#3cba9f",
        "#3e95cd",
        "#8e5ea2",
        "#f6c23e",
        "#f680ff",
        "#90b238",
        "#a47146",
        "#64608a"
    ];
    employeeCountColor.push(employeeColor[i]);
}

for (let i = 0; i < planTypeLabel.length; i++) {
    let planTypeColor = [
        "#3cba9f",
        "#3e95cd",
        "#8e5ea2",
        "#f6c23e",
        "#f680ff",
        "#90b238",
        "#a47146",
        "#64608a",
        "#f0addc",
        "#e7ce74",
        "#efa78f",
        "#aff4b7",
        "#7edced",
        "#de7d7d",
    ];
    planTypeChartColor.push(planTypeColor[i]);
}

/**begin::company_partner_search_datetime_picker */
$(function() {
    flatpickr("#company_search_date_picker", {
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
                altFormat: "F Y",
                theme: "light",
            }),
        ],
        onChange: function(selectedDates, dateStr, instance) {
            instance.set("defaultDate", selectedDates);
            let url = BASE_URL + "/partner/company_dashboard";
            window.location.assign(url + "?searchDate=" + $("#search_date").val());
        },
    });
});
/**end::company_partner_search_datetime_picker */

var ctx = document
    .getElementById("companyCountBarChart")
    .getContext("2d");

var data = {
    labels: dateDataForLabel,
    datasets: [{
        label: "企業",
        backgroundColor: "#204a9c",
        data: companyCountData,
    }, ],
};

var myBarChart = new Chart(ctx, {
    type: "bar",
    data: data,
    options: {
        onClick: function(e) {
            let companyurl = BASE_URL + "/partner/company_manage/company_search";
            var activePoint = this.getElementAtEvent(e)[0];
            if (activePoint && activePoint.hasOwnProperty("_index")) {
                var index = activePoint._index + 1;
                var datasetIndex = activePoint._datasetIndex;
            }
            var searchYearMonth = yearMonth;
            var day = index < 10 ? "0" + index : index;
            var startDate = searchYearMonth + "-" + day;
            // check which bar is clicked
            if (datasetIndex == 0)
                window.location.assign(
                    companyurl + "?startDate=" + startDate + "&endDate=" + startDate
                );

        },
        barValueSpacing: 10,
        scales: {
            xAxes: [{
                gridLines: {
                    display: false,
                    drawBorder: false,
                },
            }, ],
            yAxes: [{
                scaleLabel: {
                    display: true,
                    labelString: "数",
                },
                ticks: {
                    stepSize: stepSize,
                    min: 0,
                    max: stepSize * 5,
                    callback: function(value) {
                        return value + "";
                    },
                },
                gridLines: {
                    borderDash: [3, 5],
                    drawBorder: false,
                    zeroLineColor: "#A9A9A9",
                    zeroLineWidth: 2,
                },
            }, ],
        },
        tooltips: {
            displayColors: false,
            callbacks: {
                label: function(tooltipItem, data) {
                    let toolLabel;
                    toolLabel = [
                        "企業" +
                        ": " +
                        data.datasets[tooltipItem.datasetIndex].data[
                            tooltipItem.index
                        ] +
                        "社",
                    ];
                    return toolLabel;
                },
                // remove title
                title: function(tooltipItem, data) {
                    return;
                },
            },
        },
    },
});

function calulationStepSize(maxValue, minStepSize, stepCount) {
    let stepSize = minStepSize;
    let divisorVal = stepSize * stepCount;
    if (maxValue > divisorVal) {
        divisorVal = Math.ceil(maxValue / divisorVal);
        stepSize = divisorVal * stepSize;
    }
    return stepSize;
}

// Region Chart
new Chart(document.getElementById("companyRegionChart"), {
    type: "doughnut",
    data: {
        labels: regionLabel,
        datasets: [{
            label: "Population (millions)",
            backgroundColor: regionChartColor,
            data: companyCountListByRegionResult,
        }, ],
    },
    options: {
        title: {
            display: false,
        },
        tooltips: {
            callbacks: {
                label: function(tooltipItem, data) {
                    return (
                        data.labels[tooltipItem.index] +
                        ": " +
                        data.datasets[tooltipItem.datasetIndex].data[tooltipItem.index] +
                        " 人"
                    );
                },
                // remove title
                title: function(tooltipItem, data) {
                    return;
                },
            },
        },
    },
});

// Target Person Chart
new Chart(document.getElementById("companyTargetPersonChart"), {
    type: "doughnut",
    data: {
        labels: employeeCountLabel,
        datasets: [{
            label: "Population (millions)",
            backgroundColor: employeeCountColor,
            data: companyCountListByEmployeeCountResult,
        }, ],
    },
    options: {
        title: {
            display: false,
        },
        tooltips: {
            callbacks: {
                label: function(tooltipItem, data) {
                    return (
                        data.labels[tooltipItem.index] +
                        ": " +
                        data.datasets[tooltipItem.datasetIndex].data[tooltipItem.index] +
                        " 人"
                    );
                },
                // remove title
                title: function(tooltipItem, data) {
                    return;
                },
            },
        },
    },
});

// Plan Type Chart
new Chart(document.getElementById("companyPlanTypeChart"), {
    type: "doughnut",
    data: {
        labels: planTypeLabel,
        datasets: [{
            label: "Population (millions)",
            backgroundColor: planTypeChartColor,
            data: companyCountListByPlanTypeResult,
        }, ],
    },
    options: {
        title: {
            display: false,
        },
        tooltips: {
            callbacks: {
                label: function(tooltipItem, data) {
                    return (
                        data.labels[tooltipItem.index] +
                        ": " +
                        data.datasets[tooltipItem.datasetIndex].data[tooltipItem.index] +
                        " 人"
                    );
                },
                // remove title
                title: function(tooltipItem, data) {
                    return;
                },
            },
        },
    },
});
