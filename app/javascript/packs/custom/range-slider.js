window.rangeSlider = (id, vals, step = 1) => {
    let inputRangeHtml = $(`#${id} input[type=range]`).clone().prop("outerHTML");
    $(`#${id}`).empty();
    let stepMarksHtml = '<div class="step-marks"></div>';
    let steplablesHtml = '<div class="step-labels"></div>';
    $(`#${id}`).html(inputRangeHtml + stepMarksHtml + steplablesHtml);
  
    const min = vals[0];
    const max = vals[vals.length - 1];
  
    // initialise slider vals
    const initialVal = $(`#${id}`).data("initial")
      ? $(`#${id}`).data("initial")
      : min;
    $(`#${id} input[type=range]`)
      .attr({ min: min, max: max, step: step })
      .val(initialVal);
  
    vals.forEach((x, i) => {
      if (i < vals.length - 1) {
        $(`#${id} .step-marks`).append($("<div>"));
      }
      const label = $("<span>")
        .text(x)
        .on("click", () => $(`#${id} input[type=range]`).val(i));
      $(`#${id} .step-labels`).append(label);
    });
  
    const length = vals.length;
    const multiply = length / (length - 1);
    const widthVal = `calc(100% * ${multiply} - 25px)`;
    const marginVal = `calc(${widthVal} / ${length * -2} + 10px)`;
  
    $(`#${id} .step-labels`).css("width", widthVal);
    $(`#${id} .step-labels`).css("margin-left", marginVal);
    $(`#${id}`).show();
  };
  