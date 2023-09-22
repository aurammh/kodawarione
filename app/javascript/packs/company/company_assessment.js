$('#start-questionnaire').on('click', function () {
  $('#start-section').fadeOut('fast', function () {
    $('#questionnaire-section').fadeIn('slow');
  });
});

$('#edit-questionnaire-btn').on('click', function () {
  $('#show-questionnaire').fadeOut('fast', function () {
    $(`#edit-questionnaire`).fadeIn('slow');
  });
});

// Adding answer to list
let selectedAnswerHtml = [];
let selectedAnswerData = [];

$('.btn-check').on('click', function () {
  const current = $(this).data('current');
  const next = $(this).data('next');
  const questionNo = $(this).data('question');
  const selected = $(`#${questionNo}`).data('selected');

  // For Backend
  const questionId = $(`#${questionNo}`).data('question-id');
  const answerId = $(this).data('answer-id');

  if (!selected) {
    $(`#${questionNo}`).data('selected', true);
  }

  addAnswer(current, next, selected, questionId, answerId);

  if (next == 'final-review') {
    $('#final-review-result').empty();
    $('#final-review-result').append(selectedAnswerHtml);
  }
});

const addAnswer = (current, next, selected, questionId, answerId) => {
  const choice = $(`input[name="question_${current}_radio"]:checked`).val();
  const questionTitle = $(`#question-title-${questionId}`).text();
  const questionContent = $(`#question-content-${questionId}`).text();
  const questionAnswer = $(`#${choice} .answer`).text();

  const img = $(`#${choice} img`).clone();
  img.css({
    width: '150px',
    height: '150px',
    'margin-right': '30px',
  });
  const answer = $(`#${choice} .answer`).clone();

  var $html = $(`<div class="col-lg-6"></div>`);
  var $block = $(
    `<div class="d-flex justify-content-center align-items-center" id="block-${current}"></div>`
  );
  var $checkbox = $(
    `<input type="checkbox" class="btn-checkbox" name="final-review-checkbox[]" value="${current}" id="choice-${current}" data-question-id="${questionId}" data-answer-id="${answerId}" />`
  );
  var $label = $(
    `<label class="btn btn-outline d-flex btn-outline-dashed btn-outline-default p-7 align-items-center mb-10 w-100" for="choice-${current}"></label>`
  );
  var $answer = $(`<span class="d-block fw-bold text-start w-100"></span>`);
  $answer.append(answer);
  $answer.append(`<span class="text-muted fw-bold fs-6">.....</span>`);
  $answer.append(`<div id="area-${current}" class="rounded" style="display: none;">
                  <textarea id="textarea-${questionId}" class="form-control assessment-comment" data-kt-autosize="true" name="final-review-comments[]"></textarea>
                </div>`);
  $label.append(img);
  $label.append($answer);
  $block.append($checkbox);
  $block.append($label);
  $html.append($block);

  if (selected) {
    selectedAnswerHtml[current - 1] = $html;
  } else {
    selectedAnswerHtml.push($html);
  }

  $(`#question-${current}`).fadeOut('fast', function () {
    if (next == 'final-review') {
      $('#final-review').fadeIn('slow');
    } else {
      $(`#question-${next}`).fadeIn('slow');
    }
  });

  const obj = {
    questionnaire_id: questionId,
    answer_id: answerId,
    comment: '',
    choice_flg: false,
    delete_flg: false,
    questionTitle,
    questionContent,
    questionAnswer,
  };

  selectedAnswerData.push(obj);
};

// While choosing final choice
let choiceCounter = $('#edit-choice-count').val() || 0;
$(document).on('click', '.btn-checkbox', function (event) {
  const value = $(this).attr('value');
  const checked = $(this).is(':checked');
  const textArea = $(`#area-${value}`);
  const questionId = $(this).data('question-id');
  const answerId = $(this).data('answer-id');

  if (checked) {
    if (choiceCounter > 2) {
      event.stopPropagation();
      // Swal.fire({
      //   text: '選択できる数は3つまでです。',
      //   icon: 'error',
      //   buttonsStyling: !1,
      //   confirmButtonText: 'OK',
      //   customClass: {
      //     confirmButton: 'btn fw-bold btn-light-primary',
      //   },
      // });
      return false;
    } else {
      choiceCounter++;
      selectedAnswerData.filter((item, index) => {
        if (item.questionnaire_id == questionId) {
          selectedAnswerData[index] = {
            ...selectedAnswerData[index],
            choice_flg: true,
          };
        }
      });

      if (choiceCounter == 3) {
        $('#save').prop('disabled', false);
      }
      // textArea.fadeIn('fast');
    }
  } else {
    choiceCounter--;
    selectedAnswerData.filter((item, index) => {
      if (item.questionnaire_id == questionId) {
        selectedAnswerData[index] = {
          ...selectedAnswerData[index],
          choice_flg: false,
          comment: '',
        };
      }
    });
    // textArea.fadeOut('fast');
    $('#save').prop('disabled', true);
  }

  if (choiceCounter == 3) {
    $('.btn-checkbox').each(function () {
      const isChecked = $(this).is(':checked');
      const cbValue = $(this).val();
      if (!isChecked) {
        $(`#block-${cbValue}`).css({ opacity: 0.4 });
        $(`#block-${cbValue}`).prop('disabled', true);
      }
    });
  }
  if (choiceCounter == 2) {
    $('.btn-checkbox').each(function () {
      const isChecked = $(this).is(':checked');
      const cbValue = $(this).val();
      if (!isChecked) {
        $(`#block-${cbValue}`).css({ opacity: 1 });
        $(`#block-${cbValue}`).prop('disabled', false);
      }
    });
  }
});

// Previous btn handler
$('.prev-btn').on('click', function (e) {
  e.preventDefault();
  const prev = $(this).data('prev');
  const current = $(this).data('current');

  prevHandler(prev, current);
});

const prevHandler = (prev, current) => {
  if (current == 'final-review') {
    $(`#final-review`).fadeOut('fast', function () {
      $(`#question-${prev}`).fadeIn('slow');
    });
  } else {
    $(`#question-${current}`).fadeOut('fast', function () {
      $(`#question-${prev}`).fadeIn('slow');
    });
  }
};

// Save chosen questionnaire answer
$('#save').on('click', function (e) {
  save();
});

// Edit chosen questionnaire answer

$('#edit').on('click', function (e) {
  let counter = 0;
  let selectedUpdateAnswer = [];

  while (counter < 9) {
    counter++;
    const id = $(`#choice-${counter}`).data('id');
    const questionnaire_id = $(`#choice-${counter}`).data('question-id');
    const answer_id = $(`#choice-${counter}`).data('answer-id');
    const choice_flg = $(`#choice-${counter}`).is(':checked');
    const comment = $(`#textarea-${counter}`).val();

    const obj = {
      id,
      questionnaire_id,
      answer_id,
      choice_flg,
      comment: choice_flg ? comment : '',
    };

    selectedUpdateAnswer.push(obj);
  }

  let data = { company_answer_data: selectedUpdateAnswer };

  fetch('/company/assessments/0', {
    method: 'PUT',
    headers: {
      'X-CSRF-Token': document
        .getElementsByName('csrf-token')[0]
        .getAttribute('content'),
      'X-Requested-With': 'XMLHttpRequest',
      'Content-Type': 'application/json',
      Accept: 'application/json',
    },
    body: JSON.stringify(data),
    credentials: 'same-origin',
  }).then((response) => {
    location.reload(true);
    // And do stuff there.
    // renderLastSelectedAnswer();
    // $(`#questionnaire-section`).fadeOut('fast', function () {
    //   $(`#final-selected-answer`).fadeIn('slow');
    // });
  });
});

const save = () => {
  $('#final-selected-answer').empty();

  selectedAnswerData.filter((item, index) => {
    if (item.choice_flg) {
      const comment = $(`#textarea-${item.questionnaire_id}`).val();
      selectedAnswerData[index] = {
        ...selectedAnswerData[index],
        comment,
      };
    }
  });

  data = { company_answer_data: selectedAnswerData };

  let actionUrl = '/company/assessments';
  fetch(actionUrl, {
    method: 'POST',
    headers: {
      'X-CSRF-Token': document
        .getElementsByName('csrf-token')[0]
        .getAttribute('content'),
      'X-Requested-With': 'XMLHttpRequest',
      'Content-Type': 'application/json',
      Accept: 'application/json',
    },
    body: JSON.stringify(data),
    credentials: 'same-origin',
  }).then((response) => {
    // And do stuff there.
    renderLastSelectedAnswer();

    $(`#questionnaire-section`).fadeOut('fast', function () {
      location.reload(true);
      // $(`#final-selected-answer`).fadeIn('slow');
    });
  });
};

// Final 3 selected answer
const renderLastSelectedAnswer = () => {
  let html = [];
  selectedAnswerData.filter((item, i) => {
    if (item.choice_flg) {
      html.push(`
      <div class="card card-rounded card-bordered assessment-card mb-12">
        <div class="card-body pt-9 pb-0">
          <!--begin::Details-->
          <div class="d-flex flex-wrap flex-sm-nowrap">
            <!--begin::Image-->
            <div
              class="d-flex flex-center flex-shrink-0 bg-light rounded w-100px h-100px w-lg-150px h-lg-150px me-7 mb-4 mr-5"
            >
            <img class="assessment-image" src="/assets/company/assessment/Q${item.questionnaire_id}-${item.answer_id}.png">
            </div>
            <!--end::Image-->
            <!--begin::Wrapper-->
            <div class="flex-grow-1 d-flex align-items-center">
              <!--begin::Head-->
              <div class="d-flex justify-content-between align-items-start flex-wrap mb-2">
                <!--begin::Details-->
                <div class="d-flex flex-column">
                  <!--begin::Status-->
                  <div class="d-flex align-items-center mb-1">
                    <a
                      href="#"
                      class="text-gray-800 text-hover-primary fs-1 fw-bolder me-3"
                      > ${item.questionTitle}</a
                    >
                  </div>
                  <!--end::Status-->
                  <!--begin::Description-->
                  <div class="d-flex flex-wrap fw-bold mb-4 fs-3 text-light-secondary">
                    ${item.questionContent}
                  </div>
                  <!--end::Description-->
                </div>
                <!--end::Details-->
              </div>
              <!--end::Head-->
            </div>
            <!--end::Wrapper-->
          </div>
          <!--end::Details-->

          <div class="separator mt-6 mb-8"></div>

          <!--begin::Timeline items-->
          <div class="timeline">
            
            <!--begin::Timeline item-->
            <div class="timeline-item">
              <!--begin::Timeline line-->
              <div class="timeline-line w-40px"></div>
              <!--end::Timeline line-->
              <!--begin::Timeline icon-->
              <div class="timeline-icon symbol symbol-circle symbol-40px">
                <div class="symbol-label bg-light">
                  <!--begin::Svg Icon | path: icons/duotune/art/art005.svg-->
                  <span class="svg-icon svg-icon-2 svg-icon-gray-500">
                    <svg
                      xmlns="http://www.w3.org/2000/svg"
                      width="24"
                      height="24"
                      viewBox="0 0 24 24"
                      fill="none"
                    >
                      <path
                        opacity="0.3"
                        d="M21.4 8.35303L19.241 10.511L13.485 4.755L15.643 2.59595C16.0248 2.21423 16.5426 1.99988 17.0825 1.99988C17.6224 1.99988 18.1402 2.21423 18.522 2.59595L21.4 5.474C21.7817 5.85581 21.9962 6.37355 21.9962 6.91345C21.9962 7.45335 21.7817 7.97122 21.4 8.35303ZM3.68699 21.932L9.88699 19.865L4.13099 14.109L2.06399 20.309C1.98815 20.5354 1.97703 20.7787 2.03189 21.0111C2.08674 21.2436 2.2054 21.4561 2.37449 21.6248C2.54359 21.7934 2.75641 21.9115 2.989 21.9658C3.22158 22.0201 3.4647 22.0084 3.69099 21.932H3.68699Z"
                        fill="black"
                      />
                      <path
                        d="M5.574 21.3L3.692 21.928C3.46591 22.0032 3.22334 22.0141 2.99144 21.9594C2.75954 21.9046 2.54744 21.7864 2.3789 21.6179C2.21036 21.4495 2.09202 21.2375 2.03711 21.0056C1.9822 20.7737 1.99289 20.5312 2.06799 20.3051L2.696 18.422L5.574 21.3ZM4.13499 14.105L9.891 19.861L19.245 10.507L13.489 4.75098L4.13499 14.105Z"
                        fill="black"
                      />
                    </svg>
                  </span>
                  <!--end::Svg Icon-->
                </div>
              </div>
              <!--end::Timeline icon-->
              <!--begin::Timeline content-->
              <div class="timeline-content mb-10 mt-n1">
                <!--begin::Timeline heading-->
                <div class="pe-3 mb-5">
                  <!--begin::Title-->
                  <div class="fs-5 fw-bold mb-2">
                    Answer
                  </div>
                  <!--end::Title-->
                  <!--begin::Description-->
                  <div class="d-flex align-items-center mt-1 fs-6">
                    <!--begin::Info-->
                    <div class="text-muted me-2 fs-7">
                      Selected Answer is ${item.answerId}
                    </div>
                    <!--end::Info-->
                  </div>
                  <!--end::Description-->
                </div>
                <!--end::Timeline heading-->
                <!--begin::Timeline details-->
                <div class="overflow-auto pb-5">
                  <!--begin::Notice-->
                  <div
                    class="notice d-flex bg-light-primary rounded border-primary border border-dashed min-w-lg-600px flex-shrink-0 p-6"
                  >
                    <!--begin::Icon-->
                    <!--begin::Svg Icon | path: icons/duotune/coding/cod004.svg-->
                    <span class="svg-icon svg-icon-2tx svg-icon-primary me-4">
                      <svg
                        xmlns="http://www.w3.org/2000/svg"
                        width="24"
                        height="24"
                        viewBox="0 0 24 24"
                        fill="none"
                      >
                        <path
                          opacity="0.3"
                          d="M19.0687 17.9688H11.0687C10.4687 17.9688 10.0687 18.3687 10.0687 18.9688V19.9688C10.0687 20.5687 10.4687 20.9688 11.0687 20.9688H19.0687C19.6687 20.9688 20.0687 20.5687 20.0687 19.9688V18.9688C20.0687 18.3687 19.6687 17.9688 19.0687 17.9688Z"
                          fill="black"
                        />
                        <path
                          d="M4.06875 17.9688C3.86875 17.9688 3.66874 17.8688 3.46874 17.7688C2.96874 17.4688 2.86875 16.8688 3.16875 16.3688L6.76874 10.9688L3.16875 5.56876C2.86875 5.06876 2.96874 4.46873 3.46874 4.16873C3.96874 3.86873 4.56875 3.96878 4.86875 4.46878L8.86875 10.4688C9.06875 10.7688 9.06875 11.2688 8.86875 11.5688L4.86875 17.5688C4.66875 17.7688 4.36875 17.9688 4.06875 17.9688Z"
                          fill="black"
                        />
                      </svg>
                    </span>
                    <!--end::Svg Icon-->
                    <!--end::Icon-->
                    <!--begin::Wrapper-->
                    <div
                      class="d-flex flex-stack flex-grow-1 flex-wrap flex-md-nowrap"
                    >
                      <!--begin::Content-->
                      <div class="mb-3 mb-md-0 fw-bold">
                        <h4 class="text-gray-900 fw-bolder">
                          ${item.questionAnswer}
                        </h4>
                        <div class="fs-6 text-gray-700 pe-7">
                          ...
                        </div>
                      </div>
                      <!--end::Content-->
                    </div>
                    <!--end::Wrapper-->
                  </div>
                  <!--end::Notice-->
                </div>
                <!--end::Timeline details-->
              </div>
              <!--end::Timeline content-->
            </div>
            <!--end::Timeline item-->

            <!--begin::Timeline item-->
            <div class="timeline-item">
              <!--begin::Timeline line-->
              <div class="timeline-line w-40px"></div>
              <!--end::Timeline line-->
              <!--begin::Timeline icon-->
              <div class="timeline-icon symbol symbol-circle symbol-40px">
                <div class="symbol-label bg-light">
                  <!--begin::Svg Icon | path: icons/duotune/art/art005.svg-->
                  <span class="svg-icon svg-icon-2 svg-icon-gray-500">
                    <svg
                      xmlns="http://www.w3.org/2000/svg"
                      width="24"
                      height="24"
                      viewBox="0 0 24 24"
                      fill="none"
                    >
                      <path
                        opacity="0.3"
                        d="M2 4V16C2 16.6 2.4 17 3 17H13L16.6 20.6C17.1 21.1 18 20.8 18 20V17H21C21.6 17 22 16.6 22 16V4C22 3.4 21.6 3 21 3H3C2.4 3 2 3.4 2 4Z"
                        fill="black"
                      />
                      <path
                        d="M18 9H6C5.4 9 5 8.6 5 8C5 7.4 5.4 7 6 7H18C18.6 7 19 7.4 19 8C19 8.6 18.6 9 18 9ZM16 12C16 11.4 15.6 11 15 11H6C5.4 11 5 11.4 5 12C5 12.6 5.4 13 6 13H15C15.6 13 16 12.6 16 12Z"
                        fill="black"
                      />
                    </svg>
                  </span>
                  <!--end::Svg Icon-->
                </div>
              </div>
              <!--end::Timeline icon-->
              <!--begin::Timeline content-->
              <div class="timeline-content mb-10 mt-n1">
                <!--begin::Timeline heading-->
                <div class="pe-3 mb-5">
                  <!--begin::Title-->
                  <div class="fs-5 fw-bold mb-2">
                    Comment
                  </div>
                  <!--end::Title-->
                  <!--begin::Description-->
                  <div class="d-flex align-items-center mt-1 fs-6">
                    <!--begin::Info-->
                    <div class="text-muted me-2 fs-7">
                      Your comment and reason why you chose the answer
                    </div>
                    <!--end::Info-->
                  </div>
                  <!--end::Description-->
                </div>
                <!--end::Timeline heading-->
                <!--begin::Timeline details-->
                <div class="overflow-auto pb-5">
                  <!--begin::Notice-->
                  <div
                    class="notice d-flex bg-light-primary rounded border-primary border border-dashed min-w-lg-600px flex-shrink-0 p-6"
                  >
                    <!--begin::Icon-->
                    <!--begin::Svg Icon | path: icons/duotune/coding/cod004.svg-->
                    <span class="svg-icon svg-icon-2tx svg-icon-primary me-4">
                      <svg
                        xmlns="http://www.w3.org/2000/svg"
                        width="24"
                        height="24"
                        viewBox="0 0 24 24"
                        fill="none"
                      >
                        <path
                          opacity="0.3"
                          d="M19.0687 17.9688H11.0687C10.4687 17.9688 10.0687 18.3687 10.0687 18.9688V19.9688C10.0687 20.5687 10.4687 20.9688 11.0687 20.9688H19.0687C19.6687 20.9688 20.0687 20.5687 20.0687 19.9688V18.9688C20.0687 18.3687 19.6687 17.9688 19.0687 17.9688Z"
                          fill="black"
                        />
                        <path
                          d="M4.06875 17.9688C3.86875 17.9688 3.66874 17.8688 3.46874 17.7688C2.96874 17.4688 2.86875 16.8688 3.16875 16.3688L6.76874 10.9688L3.16875 5.56876C2.86875 5.06876 2.96874 4.46873 3.46874 4.16873C3.96874 3.86873 4.56875 3.96878 4.86875 4.46878L8.86875 10.4688C9.06875 10.7688 9.06875 11.2688 8.86875 11.5688L4.86875 17.5688C4.66875 17.7688 4.36875 17.9688 4.06875 17.9688Z"
                          fill="black"
                        />
                      </svg>
                    </span>
                    <!--end::Svg Icon-->
                    <!--end::Icon-->
                    <!--begin::Wrapper-->
                    <div
                      class="d-flex flex-stack flex-grow-1 flex-wrap flex-md-nowrap"
                    >
                      <!--begin::Content-->
                      <div class="mb-3 mb-md-0 fw-bold">
                        <h4 class="text-gray-900 fw-bolder">
                          ${item.comment}
                        </h4>
                        <div class="fs-6 text-gray-700 pe-7">
                          ...
                        </div>
                      </div>
                      <!--end::Content-->
                    </div>
                    <!--end::Wrapper-->
                  </div>
                  <!--end::Notice-->
                </div>
                <!--end::Timeline details-->
              </div>
              <!--end::Timeline content-->
            </div>
            <!--end::Timeline item-->
          </div>
        </div>
      </div>
      `);
    }
  });

  $('#final-selected-answer').append(html);
};
