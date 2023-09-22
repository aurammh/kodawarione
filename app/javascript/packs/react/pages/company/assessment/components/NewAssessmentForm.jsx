import axios from 'axios';
import React, { useRef } from 'react';
import {
  SwitchTransition,
  CSSTransition,
  TransitionGroup,
} from 'react-transition-group';
import {
  NewAssessmentAnswerCard,
  NewAssessmentConfirm,
  NewAssessmentReview,
} from '../../../../components';

const NewAssessmentForm = ({ currentNo, data, pageState, setPageState }) => {
  const [isNext, setIsNext] = React.useState(true);
  const questionnaire = data[currentNo];
  if (questionnaire && !Array.isArray(questionnaire.questionnaire_content)) {
    questionnaire.questionnaire_content =
      questionnaire.questionnaire_content &&
      questionnaire.questionnaire_content.split(' ');
  }

  const selectedQuestionnaires = pageState.selectedQuestionnaires;

  const radioClickHandler = (
    questionnaire_id,
    questionnaire_title,
    questionnaire_content,
    answer_id,
    questionnaire_answer
  ) => {
    // keep selected answer
    if (questionnaire_id) {
      const obj = {
        questionnaire_id,
        questionnaire_title,
        questionnaire_content,
        questionnaire_answer,
        answer_id,
        choice_flg: false,
        delete_flg: false,
        comment: '',
      };
      if (selectedQuestionnaires[questionnaire_id - 1]) {
        selectedQuestionnaires[questionnaire_id - 1] = obj;
      } else {
        selectedQuestionnaires.push(obj);
      }
    }

    if (data && currentNo < data.length) {
      setPageState({
        ...pageState,
        currentQuestionnaireNo: currentNo + 1,
        selectedQuestionnaires,
      });
    }
    if (data && currentNo < data.length + 1) {
      setPageState({
        ...pageState,
        currentQuestionnaireNo: currentNo + 1,
      });
    }
    setIsNext(true);
  };

  const previousBtnHandler = (e) => {
    e.preventDefault();
    setPageState({
      ...pageState,
      currentQuestionnaireNo: currentNo - 1,
    });
    setIsNext(false);
  };

  const btnRef = useRef(null);
  const saveBtnHandler = async () => {
    try {
      btnRef.current?.setAttribute('data-kt-indicator', 'on');
      btnRef.current?.setAttribute('disabled', 'true');
      setTimeout(async () => {
        const postResponse = await axios({
          url: '/company/assessments',
          method: 'POST',
          headers: {
            'X-CSRF-Token': document
              .getElementsByName('csrf-token')[0]
              .getAttribute('content'),
          },

          data: { company_answer_data: pageState.selectedQuestionnaires },
        });
        setPageState((prev) => ({
          ...prev,
          route: 'edit',
          currentQuestionnaireNo: prev.currentQuestionnaireNo - 1,
        }));
      }, 1000);
      setTimeout(() => {
        // Activate indicator
        btnRef.current?.removeAttribute('data-kt-indicator');
      }, 3000);
      // const response = await axios.get('questionnaire');
    } catch (error) {}
  };

  return (
    <div
      id="questionnaire-section"
      className="card card-rounded assessment-card p-12"
      style={{ overflow: 'hidden' }}
    >
      <TransitionGroup
        childFactory={(child) =>
          React.cloneElement(child, {
            classNames: isNext ? 'left-to-right' : 'right-to-left',
            timeout: 1000,
          })
        }
      >
        <CSSTransition
          key={currentNo}
          addEndListener={(node, done) => {
            node.addEventListener('transitionend', done, false);
          }}
          classNames="right-to-left"
          timeout={1000}
        >
          <>
            {currentNo < data.length && (
              <div
                style={{ overflow: 'hidden' }}
                className="fv-row"
                data-selected="false"
                data-question-id='<%= "#{question_index}" %>'
              >
                <h3 className="d-flex flex-column mb-5">
                  <span id="" className="card-label fw-bolder fs-1 mb-1">
                    {questionnaire.questionnaire_title}
                  </span>

                  {typeof questionnaire.questionnaire_content === 'object' ? (
                    questionnaire.questionnaire_content.map((m, i) => (
                      <span
                        key={i}
                        id='<%= "question-content-#{question_index}" %>'
                        className="text-light-secondary mt-1 fw-bold fs-12"
                      >
                        {m}
                      </span>
                    ))
                  ) : (
                    <span
                      id='<%= "question-content-#{question_index}" %>'
                      className="text-light-secondary mt-1 fw-bold fs-12"
                    >
                      {questionnaire.questionnaire_content}
                    </span>
                  )}
                </h3>

                <div className="row mt-3">
                  {questionnaire.answer.map((answer, i) => {
                    return (
                      <NewAssessmentAnswerCard
                        key={i}
                        pageState={pageState}
                        questionnaire={questionnaire}
                        answer={answer}
                        onClick={radioClickHandler}
                      />
                    );
                  })}
                </div>
              </div>
            )}

            {currentNo == data.length && (
              <NewAssessmentReview
                isStudent={false}
                editCounter={null}
                data={data}
                pageState={pageState}
                setPageState={setPageState}
                editing={{ status: false }}
                description2="選択した項目より、自社の特徴としてよりあてはまる特徴を３つ選択して下さい。"
              />
            )}

            {currentNo == data.length + 1 && (
              <NewAssessmentConfirm
                title="３つの特徴を選んだ理由をそれぞれ記載ください。"
                pageState={pageState}
                setPageState={setPageState}
                isConfirmPage={true}
              />
            )}
          </>
        </CSSTransition>
      </TransitionGroup>

      {currentNo != 0 && (
        <div className="d-flex align-items-center justify-content-between">
          <a
            href="#"
            className="prev-btn btn btn-icon btn-bg-light btn-active-color-primary btn-sm me-1"
            data-prev='<%= "#{q_index}" %>'
            data-questionnaire='<%= question_index > 8 ? "final-review" : "#{question_index}" %>'
            onClick={(e) => previousBtnHandler(e)}
          >
            <span className="svg-icon svg-icon-muted svg-icon-2hx">
              <svg
                xmlns="http://www.w3.org/2000/svg"
                width="24"
                height="24"
                viewBox="0 0 24 24"
                fill="none"
              >
                <path
                  d="M11.2657 11.4343L15.45 7.25C15.8642 6.83579 15.8642 6.16421 15.45 5.75C15.0358 5.33579 14.3642 5.33579 13.95 5.75L8.40712 11.2929C8.01659 11.6834 8.01659 12.3166 8.40712 12.7071L13.95 18.25C14.3642 18.6642 15.0358 18.6642 15.45 18.25C15.8642 17.8358 15.8642 17.1642 15.45 16.75L11.2657 12.5657C10.9533 12.2533 10.9533 11.7467 11.2657 11.4343Z"
                  fill="black"
                />
              </svg>
            </span>
          </a>

          {pageState.currentQuestionnaireNo == data.length && (
            <button
              id="save"
              className="btn btn-primary font-weight-bold py-2 px-6"
              style={{
                marginLeft: '20px',
                opacity: pageState.selectedCount == 3 ? 1 : 0,
                transition: '0.6s',
              }}
              onClick={() => radioClickHandler(null)}
            >
              確認画面へ
            </button>
          )}

          {pageState.currentQuestionnaireNo == data.length + 1 && (
            <div className="d-flex justify-content-start">
              <button
                id="save"
                ref={btnRef}
                className="btn btn-primary font-weight-bold py-2 px-6"
                style={{
                  marginLeft: '20px',
                }}
                onClick={() => saveBtnHandler()}
              >
                <span className="indicator-label">保存</span>
                <span className="indicator-progress">
                  取得中...{' '}
                  <span className="spinner-border spinner-border-sm align-middle ms-2"></span>
                </span>
              </button>
            </div>
          )}
        </div>
      )}
    </div>
  );
};

export default NewAssessmentForm;
