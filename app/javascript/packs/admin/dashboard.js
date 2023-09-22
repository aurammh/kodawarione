import monthSelectPlugin from "flatpickr/dist/plugins/monthSelect";
import "flatpickr/dist/plugins/monthSelect/style.css";
import { Japanese } from "flatpickr/dist/l10n/ja";

var studentCountData = studentCountListResult;
var companyCountData = companyCountListResult;
var dateDataForLabel = dateArrayListForLabel;
var maxValueForStep = maxValueInArray;
var stepSize = calulationStepSize(maxValueForStep, 5, 5);
var genderLabel = genderLabelList;
var studentCountListByGenderResult = studentCountListByGender;
var regionLabel = regionLabelList;
var studentCountListByRegionResult = studentCountListByRegion;
var schoolTypeLabel = schoolTypeLabelList;
var studentCountListBySchoolTypeResult = studentCountListBySchoolType;
// var steamsInfoLabel = steamsInfoLabelList;
// var studentCountListBySteamsInfoResult = studentCountListBySteamsInfo;
var postalLabel = postalLabelList;
var companyCountListByPostalCityResult = companyCountListByPostalCity;
var companyRegionLabel = companyRegionLabelList;
var companyCountListByRegionResult = companyCountListByRegion;
var companyCountListByVacancyResult = companyCountListByVacancy;
var companyCountListByNoVacancyResult = companyCountListByNoVacancy;

var partnerPostalLabel = partnerPostalLabelList;
var partnerCountListByPostalCityResult = partnerCountListByPostalCity;
var partnerRegionLabel = partnerRegionLabelList;
var partnerCountListByRegionResult = partnerCountListByRegion;
var partnerPlanLabel = planLabelList;
var partnerCountListByPlanResult = partnerCountListByPlan;
var companyEmployeeCountLabel = companyEmployeeCountLabelList;
var companyCountListByEmployeeCountResult = companyCountByEmployeeCountResult;
var planTypeLabel = planTypeLabelList;
var companyCountListByPlanTypeResult = companyCountByPlanTypeResult;

var regionChartColorCompany = [];
var postalCityChartColor = [];
var regionChartColor = [];
var schoolChartColor = [];
var employeeChartColor = [];
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

for (let i = 0; i < schoolTypeLabel.length; i++) {
    let schoolTypeColor = [
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
    schoolChartColor.push(schoolTypeColor[i]);
}

for (let i = 0; i < companyRegionLabel.length; i++) {
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
    regionChartColorCompany.push(regionColor[i]);
}

for (let i = 0; i < postalLabel.length; i++) {
    let postalCityColor = [
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
    postalCityChartColor.push(postalCityColor[i]);
}

for (let i = 0; i < companyEmployeeCountLabel.length; i++) {
    let employeeColor = [
        "#3cba9f",
        "#3e95cd",
        "#8e5ea2",
        "#f6c23e",
        "#f680ff",
        "#90b238",
        "#a47146",
    ];
    employeeChartColor.push(employeeColor[i]);
}

for (let i = 0; i < planTypeLabel.length; i++) {
    let schoolTypeColor = [
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
    planTypeChartColor.push(schoolTypeColor[i]);
}

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
                altFormat: "F Y",
                theme: "light",
            }),
        ],
        onChange: function(selectedDates, dateStr, instance) {
            instance.set("defaultDate", selectedDates);
            let url = BASE_URL + "/admin/dashboard/index";
            window.location.assign(url + "?searchDate=" + $("#search_date").val());
        },
    });
    /**end::admin_search_datetime_picker */
});

var ctx = document
    .getElementById("studentCompanyCountBarChart")
    .getContext("2d");

var data = {
    labels: dateDataForLabel,
    datasets: [{
            label: "学生",
            backgroundColor: "#f4d01f",
            data: studentCountData,
        },
        {
            label: "企業",
            backgroundColor: "#204a9c",
            data: companyCountData,
        },
    ],
};

var myBarChart = new Chart(ctx, {
    type: "bar",
    data: data,
    options: {
        onClick: function(e) {
            let studenturl = BASE_URL + "/admin/student_manage/student_search";
            let companyurl = BASE_URL + "/admin/company_manage/company_search";
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
                    studenturl +
                    "?date_type=created_at&startDate=" +
                    startDate +
                    "&endDate=" +
                    startDate
                );
            else if (datasetIndex == 1)
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
                    if (tooltipItem.datasetIndex == 0) {
                        toolLabel = [
                            "学生" +
                            ": " +
                            data.datasets[tooltipItem.datasetIndex].data[
                                tooltipItem.index
                            ] +
                            "人",
                        ];
                    } else {
                        toolLabel = [
                            "企業" +
                            ": " +
                            data.datasets[tooltipItem.datasetIndex].data[
                                tooltipItem.index
                            ] +
                            "社",
                        ];
                    }

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

// Gender Chart
new Chart(document.getElementById("studentGenderChart"), {
    type: "doughnut",
    data: {
        labels: genderLabel,
        datasets: [{
            label: "Population (millions)",
            backgroundColor: ["#3e95cd", "#8e5ea2", "#3cba9f"],
            data: studentCountListByGenderResult,
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

// Region Chart
new Chart(document.getElementById("studentRegionChart"), {
    type: "doughnut",
    data: {
        labels: regionLabel,
        datasets: [{
            label: "Population (millions)",
            backgroundColor: regionChartColor,
            data: studentCountListByRegionResult,
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

// SchoolType Chart
new Chart(document.getElementById("studentSchoolTypeChart"), {
    type: "doughnut",
    data: {
        labels: schoolTypeLabel,
        datasets: [{
            label: "Population (millions)",
            backgroundColor: schoolChartColor,
            data: studentCountListBySchoolTypeResult,
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

// Region Chart (company)
new Chart(document.getElementById("companyRegionChart"), {
    type: "doughnut",
    data: {
        labels: companyRegionLabel,
        datasets: [{
            label: "Population (millions)",
            backgroundColor: regionChartColorCompany,
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
                        " 社"
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

// Employee Count Chart (company)
new Chart(document.getElementById("companyEmployeeCountChart"), {
    type: "doughnut",
    data: {
        labels: companyEmployeeCountLabel,
        datasets: [{
            label: "Population (millions)",
            backgroundColor: employeeChartColor,
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
                        " 社"
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

// Postal City Chart (partner)
new Chart(document.getElementById("partnerPostalCityChart"), {
    type: "doughnut",
    data: {
        labels: partnerPostalLabel,
        datasets: [{
            label: "Population (millions)",
            backgroundColor: postalCityChartColor,
            data: partnerCountListByPostalCityResult,
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

// Region Chart (partner)
new Chart(document.getElementById("partnerRegionChart"), {
    type: "doughnut",
    data: {
        labels: partnerRegionLabel,
        datasets: [{
            label: "Population (millions)",
            backgroundColor: regionChartColorCompany,
            data: partnerCountListByRegionResult,
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

// Plan Chart (partner)
new Chart(document.getElementById("partnerPlanChart"), {
    type: "doughnut",
    data: {
        labels: partnerPlanLabel,
        datasets: [{
            label: "Population (millions)",
            backgroundColor: schoolChartColor,
            data: partnerCountListByPlanResult,
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
