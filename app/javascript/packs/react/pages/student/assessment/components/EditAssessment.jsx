import axios from 'axios';
import React, { useRef } from 'react';
import {
  SwitchTransition,
  CSSTransition,
  TransitionGroup,
} from 'react-transition-group';
import {
  NewAssessmentAnswerCard,
  NewAssessmentReview,
} from '../../../../components';

const EditAssessment = ({
  pageState,
  setPageState,
  isStudent,
  questionnaireData,
}) => {
  const [editing, setEditing] = React.useState({
    status: true,
  });

  const [isNext, setIsNext] = React.useState(true);

  const navigate = (val) => {
    setPageState((prev) => ({
      ...prev,
      currentQuestionnaireNo: pageState.currentQuestionnaireNo + val,
      editStatus: true,
    }));
  };

  const changeEditStatus = () => {
    setPageState({
      ...pageState,
      editStatus: true,
    });
  };

  const btnRef = useRef(null);
  const updateBtnHandler = async () => {
    try {
      btnRef.current?.setAttribute('data-kt-indicator', 'on');
      btnRef.current?.setAttribute('disabled', 'true');

      setTimeout(async () => {
        await axios({
          url: '/student/questionnarie_assessments/0',
          method: 'PUT',
          headers: {
            'X-CSRF-Token': document
              .getElementsByName('csrf-token')[0]
              .getAttribute('content'),
          },

          data: { student_answer_data: pageState.selectedQuestionnaires },
        });
        setPageState((prev) => ({
          ...prev,
          editStatus: false,
          currentQuestionnaireNo: 0,
        }));
        setEditing((prev) => ({
          ...prev,
          status: false,
        }));
      }, 1000);

      setTimeout(() => {
        // Activate indicator
        btnRef.current?.removeAttribute('data-kt-indicator');
      }, 3000);

      // const response = await axios.get('questionnaire');
    } catch (error) {}
  };

  const questionnaire = questionnaireData[pageState.currentQuestionnaireNo];

  const radioClickHandler = (
    questionnaire_id,
    questionnaire_title,
    questionnaire_content,
    answer_id,
    questionnaire_answer
  ) => {
    const tempDataArr = pageState.selectedQuestionnaires;
    tempDataArr[pageState.currentQuestionnaireNo] = {
      ...pageState.selectedQuestionnaires[pageState.currentQuestionnaireNo],
      answer_id,
      questionnaire_answer,
    };

    setPageState({
      ...pageState,
      currentQuestionnaireNo: pageState.currentQuestionnaireNo + 1,
      selectedQuestionnaires: tempDataArr,
    });

    setIsNext(true);
  };

  const previousBtnHandler = (e) => {
    e.preventDefault();
    setPageState({
      ...pageState,
      currentQuestionnaireNo: pageState.currentQuestionnaireNo - 1,
    });
    setIsNext(false);
  };

  return (
    <div className="overflow-hidden">
      <SwitchTransition mode="out-in">
        <CSSTransition
          // key={pageState.currentQuestionnaireNo}
          key={editing.status}
          addEndListener={(node, done) => {
            node.addEventListener('transitionend', done, false);
          }}
          classNames="fade"
        >
          {pageState.editStatus ? (
            <>
              <div
                id="questionnaire-section"
                className="card card-rounded assessment-card pb-10 pt-8 px-10"
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
                    key={pageState.currentQuestionnaireNo}
                    addEndListener={(node, done) => {
                      node.addEventListener('transitionend', done, false);
                    }}
                    classNames="right-to-left"
                    timeout={1000}
                  >
                    <>
                      {pageState.currentQuestionnaireNo <
                        questionnaireData.length && (
                        <div
                          style={{ overflow: 'hidden' }}
                          className="fv-row"
                          data-selected="false"
                          data-question-id='<%= "#{question_index}" %>'
                        >
                          <h3 className="d-flex flex-column mb-5">
                            <span
                              id=""
                              className="card-label fw-bolder fs-1 mb-2"
                            >
                              {questionnaire.questionnaire_title}
                            </span>

                            {typeof questionnaire.questionnaire_content ===
                            'object' ? (
                              questionnaire.questionnaire_content.map(
                                (m, i) => (
                                  <span
                                    key={i}
                                    id='<%= "question-content-#{question_index}" %>'
                                    className="text-light-secondary mt-1 fw-bold fs-12"
                                  >
                                    {m}
                                  </span>
                                )
                              )
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

                      {pageState.currentQuestionnaireNo ==
                        questionnaireData.length && (
                        <NewAssessmentReview
                          isStudent
                          editCounter={null}
                          data={questionnaireData}
                          pageState={pageState}
                          setPageState={setPageState}
                          editing={{ status: false }}
                        />
                      )}
                    </>
                  </CSSTransition>
                </TransitionGroup>
                {pageState.currentQuestionnaireNo != 0 && (
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
                    {pageState.currentQuestionnaireNo ==
                      questionnaireData.length && (
                      <div className="d-flex justify-content-start">
                        <button
                          ref={btnRef}
                          id="save"
                          className="btn btn-primary font-weight-bold py-2 px-6"
                          style={{
                            marginLeft: '20px',
                          }}
                          onClick={() => updateBtnHandler()}
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
            </>
          ) : (
            <NewAssessmentReview
              editCounter={null}
              pageState={pageState}
              setPageState={setPageState}
              editing={{ status: false }}
              isStudent={isStudent}
              onClick1={changeEditStatus}
            />
          )}
        </CSSTransition>
      </SwitchTransition>
    </div>
  );
};

export default EditAssessment;
