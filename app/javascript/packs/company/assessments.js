var chartValues = [];
let evaluateInfos = [];

$(function () {
  renderDualListBox();

  $("#radarDiv").hide();

  $("#execute").click(function () {
    for (let i = 0; i < chartValues.length; i++) {
      let info = Object.create({
        attitude: chartValues[i],
        points: $("#pt" + chartValues[i]).val(),
        reason: $("#reason" + chartValues[i]).val(),
      });
      evaluateInfos.push(info);
    }
    if (chartValues.length != 0) {
      $("#radarDiv").show();
      renderChart();
      renderReasonBox();
    } else {
      alert("Please choose category, first!!!");
      $("#radarDiv").hide();
    }
    evaluateInfos = [];
  });
});

function renderChart() {
  let labelValues = [],
    dataValues = [];
  for (var item of evaluateInfos) {
    labelValues.push(item.attitude);
    dataValues.push(item.points);
  }
  const data = {
    labels: labelValues,
    datasets: [
      {
        label: "自社評価",
        data: dataValues,
        fill: true,
        backgroundColor: "rgba(27, 197, 189, 0.2)",
        borderColor: "#1bc5bd",
        pointBackgroundColor: "#1bc5bd",
        pointBorderColor: "#fff",
        pointHoverBackgroundColor: "#fff",
        pointHoverBorderColor: "rgb(255, 99, 132)",
      },
    ],
  };

  const config = {
    type: "radar",
    data: data,
    options: {
      elements: {
        line: {
          borderWidth: 3,
        },
      },
    },
  };

  const myChart = new Chart(document.getElementById("myChart"), config);
}

function renderReasonBox() {
  $("#reason-box > div").remove();
  for (var item of evaluateInfos) {
    $("#reason-box").append(
      '<div class="d-flex p-2 mb-2">' +
        '<div class="py-5 px-2 border border-dark flex-fill">' +
        '<p class="text-left"> A: ' +
        item.attitude +
        "</p>" +
        '<p class="text-left">＜理由: ' +
        item.reason +
        " ＞</p>" +
        "</div>" +
        "</div>"
    );
  }
}

function renderDualListBox() {
  // init dual listbox
  if ($("#kt_dual_listbox_1").length) {
    var dualListBox = new DualListbox("#kt_dual_listbox_1", {
      availableTitle: "Available options",
      selectedTitle: "Selected options",
      addButtonText: "Add",
      removeButtonText: "Remove",
      addAllButtonText: "Add All",
      removeAllButtonText: "Remove All",
    });

    dualListBox.addEventListener("added", function (event) {
      let addItem = event.addedElement.outerText;
      chartValues.push(addItem);
      $("#fillPoint").append(
        '<div class="row p-1" id="' +
          addItem +
          '">' +
          '<div class="col">' +
          '<span class="font-weight-bolder ml-2">' +
          addItem +
          "</span>" +
          '<input type="text" class="form-control my-3" placeholder="点" id="pt' +
          addItem +
          '"/>' +
          '<textarea class="form-control" rows="3" placeholder="理由"  id="reason' +
          addItem +
          '"></textarea>' +
          "</div>" +
          "</div>"
      );

      if (chartValues.length == 5) {
        disableDualBox();
      }
    });

    dualListBox.addEventListener("removed", function (event) {
      chartValues.find((element, index) => {
        if (element === event.removedElement.outerText) {
          chartValues.splice(index, 1);
        }
      });
      $("#" + event.removedElement.outerText).remove();

      if (chartValues.length < 5) {
        enableDualBox();
      }
    });
  }
}

function disableDualBox() {
  $(".dual-listbox__available > li").css("pointer-events", "none");
  $(".dual-listbox__available > li").css("opacity", 0.2);
  $(".dual-listbox__button:nth-child(1)").css("pointer-events", "none");
  $(".dual-listbox__button:nth-child(1)").css("opacity", 0.3);
  $(".dual-listbox__button:nth-child(2)").css("pointer-events", "none");
  $(".dual-listbox__button:nth-child(2)").css("opacity", 0.3);
}

function enableDualBox() {
  $(".dual-listbox__available> li").removeAttr("style");
  $(".dual-listbox__button:nth-child(1)").removeAttr("style");
  $(".dual-listbox__button:nth-child(2)").removeAttr("style");
}
