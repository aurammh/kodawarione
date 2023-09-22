var commitmentAbilityListData = commitmentAbilityList;
var commitmentAbilityResultData = commitmentAbilityResult;
let commitment_abilities_data = []; // For server
let selectedAbilities = []; // For UI render

$('.form-check-input').on('click', function () {
  const selectedAbilityId = $(this).data('id');
  const isChecked = $(this).is(':checked');

  // Find selected ability data from server response since UI give only ID
  let selectedAbility = commitmentAbilityListData.find(
    (item) => item.id === selectedAbilityId
  );

  // If checkbox is checked, add to selectedAbilities and commitment_abilities_data
  if (isChecked) {
    // For server request
    commitment_abilities_data.push({
      ability_value: '',
      ability_reason: '',
      name: selectedAbility.name,
      m_commitment_abilities_id: selectedAbilityId,
    });

    // For UI render
    selectedAbilities.push({
      ...selectedAbility,
      ability_value: '',
      ability_reason: '',
    });
  } else {
    commitment_abilities_data = commitment_abilities_data.filter(
      (item) => item.m_commitment_abilities_id !== selectedAbilityId
    );

    selectedAbilities = selectedAbilities.filter(
      (item) => item.id !== selectedAbilityId
    );
  }

  renderMain();
});

$(function () {
  selectedAbilities = commitmentAbilityResultData.map((m) => ({
    ability_value: m.ability_value,
    ability_reason: m.ability_reason,
    name: m.name,
    id: m.m_commitment_abilities_id,
  }));

  commitment_abilities_data = commitmentAbilityResultData.map((m) => ({
    ability_value: m.ability_value,
    ability_reason: m.ability_reason,
    m_commitment_abilities_id: m.m_commitment_abilities_id,
    name: m.name,
  }));

  renderMain();

  $(document).on('click', '.ability-value', function (e) {
    $('#ability-error').empty();

    const current = $(this);
    const [index, id] = current.data('index').split('-');
    const ability_value = $(this).data('ability-value');

    $(`#ability-${id} .ability-value`).each(function () {
      $(this).addClass('badge-light-primary').removeClass('badge-primary');
      current.addClass('badge-primary').removeClass('badge-light-primary');
    });

    commitment_abilities_data[index] = {
      ...commitment_abilities_data[index],
      ability_value,
    };

    selectedAbilities[index] = {
      ...selectedAbilities[index],
      ability_value,
    };

    console.log(commitment_abilities_data, ' | ', selectedAbilities);
  });

  $(document).on('change', '.ability-reason', function (e) {
    $('#ability-error').empty();

    const current = $(this);
    const [index, id] = current.data('index').split('-');
    const ability_reason = current.val();

    commitment_abilities_data[index] = {
      ...commitment_abilities_data[index],
      ability_reason,
    };

    selectedAbilities[index] = {
      ...selectedAbilities[index],
      ability_reason,
    };
  });
});

$('#ability-save-company-btn').on('click', function () {
  const checkRangeEmpty = commitment_abilities_data.find(
    (f) =>
      f.ability_value == null ||
      f.ability_value === '' ||
      typeof f.ability_value == 'undefined'
  );

  const checkReasonEmpty = commitment_abilities_data.find(
    (f) =>
      f.ability_reason == null ||
      f.ability_reason === '' ||
      typeof f.ability_reason == 'undefined'
  );

  if (checkRangeEmpty || checkReasonEmpty) {
    $('#ability-error')
      .html('評価と理由を入力してください。')
      .addClass('label fw-bolder text-danger');
  } else {
    $('#ability-save-company-btn').addClass('disabled');

    fetch('/company/commitment_ability/1', {
      method: 'PUT',
      headers: {
        'X-CSRF-Token': document
          .getElementsByName('csrf-token')[0]
          .getAttribute('content'),
        'X-Requested-With': 'XMLHttpRequest',
        'Content-Type': 'application/json',
        Accept: 'application/json',
      },
      body: JSON.stringify({
        company_ability_data: commitment_abilities_data,
      }),
      credentials: 'same-origin',
    }).then((response) => {
      // location.reload(true);
      window.location = '/company/commitment_ability';
    });
  }
});

$('#ability-save-btn').on('click', function () {
  const checkRangeEmpty = commitment_abilities_data.find(
    (f) =>
      f.ability_value == null ||
      f.ability_value === '' ||
      typeof f.ability_value == 'undefined'
  );

  const checkReasonEmpty = commitment_abilities_data.find(
    (f) =>
      f.ability_reason == null ||
      f.ability_reason === '' ||
      typeof f.ability_reason == 'undefined'
  );

  if (checkRangeEmpty || checkReasonEmpty) {
    $('#ability-error')
      .html('評価と理由を入力してください。')
      .addClass('label fw-bolder text-danger');
  } else {
    $('#ability-save-btn').addClass('disabled');
    fetch('/student/commitment_ability/1', {
      method: 'PUT',
      headers: {
        'X-CSRF-Token': document
          .getElementsByName('csrf-token')[0]
          .getAttribute('content'),
        'X-Requested-With': 'XMLHttpRequest',
        'Content-Type': 'application/json',
        Accept: 'application/json',
      },
      body: JSON.stringify({
        student_ability_data: commitment_abilities_data,
      }),
      credentials: 'same-origin',
    }).then((response) => {
      location.reload(true);
      window.location = '/student/commitment_ability';
    });
  }
});

const renderMain = () => {
  $('#selected-abilities').empty();
  $('#selected-reasons').empty();

  if (selectedAbilities.length == 0) {
    $('#ability-reason').hide();
  } else {
    $('#ability-reason').show();
  }

  if (selectedAbilities.length == 3) {
    $('#ability-save-btn').show();
    $('#ability-save-company-btn').show();
  } else {
    $('#ability-save-btn').hide();
    $('#ability-save-company-btn').hide();
  }

  // Selected Abilities - Right Side
  selectedAbilities.map((item, i) => {
    let selectedAbilityHtml = `
    <div class="d-flex align-items-center" style="padding-bottom: 10px;">
    <span class="badge badge-circle badge-primary min-w-25px min-h-25px" style="margin-right: 5px;">${
      i + 1
    }</span>
    <label class="fs-6">${item.name}</label>
    </div>`;
    $('#selected-abilities').fadeIn().append(selectedAbilityHtml);
  });

  // Ability Value and Reasons - Bottom Side
  selectedAbilities.map((item, i) => {
    const rangeHTML = renderRange(item, i);

    let selectedReasonHtml = `
    <div class="col-xl-4 col-lg-8 col-md-9 col-sm-12 mb-6 text-center">
      <div class="d-flex justify-content-center"><span class="badge badge-circle badge-white" style="border: 1px solid gray;">${
        i + 1
      }</span>
          <div class="fs-5 fw-bolder mb-5" style="margin-left: 5px;">${
            item.name
          }</div>
      </div>
      <div id="ability-${
        item.id
      }" class="d-flex justify-content-between align-items-center ability-value-div" style="padding-bottom: 10px;">
      ${rangeHTML.html()}
      </div>
      <div class="d-flex mb-5" style="justify-content: space-between;">
          <span class="label fw-bold text-primary">低い</span><span class="label fw-bold text-primary">高い</span>
      </div>
      <textarea class="form-control form-control-solid mb-8 ability-reason" rows="5" data-index="${i}-${
      item.id
    }" placeholder="選択理由を教えてください。" style="overflow: hidden; min-width: 100%;">${
      item.ability_reason
    }</textarea>
    </div>`;

    $('#selected-reasons').append(selectedReasonHtml);
  });

  $('.form-check-input').each(function () {
    const checked = $(this).is(':checked');
    if (!checked && selectedAbilities.length > 2) {
      $(this).prop('disabled', true);
    }

    if (selectedAbilities.length == 2) {
      $(this).prop('disabled', false);
    }
  });
};

const renderRange = (selectedAbility, index) => {
  const item = selectedAbility;
  let html = $(
    `<div id="ability-${item.id}" class="d-flex justify-content-between align-items-center ability-value-div" style="padding-bottom: 10px;" />`
  );

  for (let i = 1; i < 11; i++) {
    html.append(
      `<span
        class="hoverable badge badge-square ability-value ${
          item.ability_value !== i ? 'badge-light-primary' : 'badge-primary'
        }"
        data-index="${index}-${item.id}"
        data-ability-value=${i}
        style="width: 2.5rem; height: 2.5rem;"
      >
        ${i}
      </span>`
    );
  }

  return html;
};
