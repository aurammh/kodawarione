var industryLabel = industryLabelList;
var companyCountListByIndustryResult = companyCountListByIndustry;
var postalLabel = postalLabelList;
var companyCountListByPostalCityResult = companyCountListByPostalCity;
var companyRegionLabel = companyRegionLabelList;
var companyCountListByRegionResult = companyCountListByRegion;
var deleteLabel = deleteLabelList;
var companyCountListByDeleteResult = companyCountListByDelete;
var companyCountListByVacancyResult = companyCountListByVacancy;
var companyCountListByNoVacancyResult = companyCountListByNoVacancy;
var regionChartColor = [];
var postalCityChartColor = [];

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
    regionChartColor.push(regionColor[i]);
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

// Industry Chart
// new Chart(document.getElementById("companyIndustryChart"), {
//     type: "doughnut",
//     data: {
//         labels: industryLabel,
//         datasets: [{
//             label: "Population (millions)",
//             backgroundColor: ["#3e95cd", "#8E5EA2", "#8E5EA7"],
//             data: companyCountListByIndustryResult,
//         }, ],
//     },
//     options: {
//         title: {
//             display: false,
//         },
//         tooltips: {
//             callbacks: {
//                 label: function(tooltipItem, data) {
//                     return (
//                         data.labels[tooltipItem.index] +
//                         ": " +
//                         data.datasets[tooltipItem.datasetIndex].data[tooltipItem.index] +
//                         " 人"
//                     );
//                 },
//                 // remove title
//                 title: function(tooltipItem, data) {
//                     return;
//                 },
//             },
//         },
//     },
// });

// Postal City Chart
new Chart(document.getElementById("companyPostalCityChart"), {
    type: "doughnut",
    data: {
        labels: postalLabel,
        datasets: [{
            label: "Population (millions)",
            backgroundColor: postalCityChartColor,
            data: companyCountListByPostalCityResult,
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

// Region Chart
new Chart(document.getElementById("companyRegionChart"), {
    type: "doughnut",
    data: {
        labels: companyRegionLabel,
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

// Vacancy Chart
new Chart(document.getElementById("companyVacancyChart"), {
    type: "doughnut",
    data: {
        labels: [" あり"," なし"],
        datasets: [{
            label: "Population (millions)",
            backgroundColor: ["#3cba9f", "#8e5ea2"],
            data: [companyCountListByVacancyResult,companyCountListByNoVacancyResult],
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

// Delete Chart
// new Chart(document.getElementById("companyDeleteChart"), {
//     type: "doughnut",
//     data: {
//         labels: deleteLabel,
//         datasets: [{
//             label: "Population (millions)",
//             backgroundColor: ["#3e95cd", "#8E5EA2"],
//             data: companyCountListByDeleteResult,
//         }, ],
//     },
//     options: {
//         title: {
//             display: false,
//         },
//         tooltips: {
//             callbacks: {
//                 label: function(tooltipItem, data) {
//                     return (
//                         data.labels[tooltipItem.index] +
//                         ": " +
//                         data.datasets[tooltipItem.datasetIndex].data[tooltipItem.index] +
//                         " 人"
//                     );
//                 },
//                 // remove title
//                 title: function(tooltipItem, data) {
//                     return;
//                 },
//             },
//         },
//     },
// });