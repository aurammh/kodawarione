import React from 'react';
import { images } from '../assets';
import EditAssessmentAnswer from './EditAssessmentAnswer';
import NewAssessmentReviewCard from './NewAssessmentReviewCard';

let counter = 0;
const NewAssessmentReview = ({
  editCounter,
  pageState,
  setPageState,
  editing,
  setEditing,
  description2,
  note,
  isStudent,
  onClick1,
}) => {
  const checkHandler = (event, qId, aId) => {
    counter = editCounter ? editCounter : counter;
    if (event.target.checked) {
      if (counter > 2) {
        event.stopPropagation();
      } else {
        counter++;
        setPageState((prevState) => ({
          ...pageState,
          selectedCount: counter,
          selectedQuestionnaires: prevState.selectedQuestionnaires.map((obj) =>
            obj.questionnaire_id == qId
              ? Object.assign(obj, { choice_flg: event.target.checked })
              : obj
          ),
        }));
      }
    } else {
      counter--;
      setPageState((prevState) => ({
        ...pageState,
        selectedCount: counter,
        selectedQuestionnaires: prevState.selectedQuestionnaires.map((obj) =>
          obj.questionnaire_id == qId
            ? Object.assign(obj, { choice_flg: event.target.checked })
            : obj
        ),
      }));
    }
  };

  const editAnswerHandler = (questionnaire_id, questionIndex) => {
    const temp = pageState.questionnaireData.find(
      (item) => item.questionnaire_id == questionnaire_id
    );

    setEditing({
      status: true,
      selectedQuestionnaire: temp,
      questionIndex,
    });
  };

  const onClick1Handler = () => {
    onClick1 && onClick1();
  };

  return (
    <div className="fv-row ">
      {!editing.status ? (
        <>
          {isStudent && (
            <>
              <div className="d-flex justify-content-between">
                <h3 className="d-flex flex-column mb-5">
                  <div
                    className="d-flex justify-content-between align-items-center"
                    style={{ minHeight: '40px' }}
                  >
                    <span className="card-label fw-bolder fs-1 mb-1">
                      {'選択結果'}
                    </span>
                  </div>
                </h3>

                {!pageState.editStatus && pageState.route == 'edit' && (
                  <div>
                    <button
                      id="save"
                      className="btn btn-primary font-weight-bold py-2 px-6"
                      style={{
                        marginLeft: '20px',
                        opacity: 1,
                        transition: '0.6s',
                      }}
                      onClick={onClick1Handler}
                    >
                      再選択する
                    </button>
                  </div>
                )}
              </div>

              <div
                className={
                  isStudent &&
                  pageState.editStatus == true &&
                  pageState.route == 'edit'
                    ? ''
                    : isStudent &&
                      pageState.editStatus == false &&
                      pageState.route == 'new'
                    ? ''
                    : 'card card-rounded card-bordered assessment-card my-0 px-10 pt-10'
                }
              >
                <div id="final-review-result" className="row">
                  {pageState.selectedQuestionnaires.map((item, i) => {
                    const questionIndex =
                      pageState.selectedQuestionnaires.findIndex(
                        (x) => x.questionnaire_id == item.questionnaire_id
                      );

                    return (
                      <div className="col-lg-3 col-md-6 col-sm-6">
                        <div
                          className="d-flex justify-content-center align-items-center position-relative"
                          style={{
                            opacity:
                              pageState.selectedCount == 3 &&
                              !item.choice_flg &&
                              0.4,
                            transition: '0.6s',
                          }}
                        >
                          <input
                            type="checkbox"
                            className="btn-checkbox"
                            id={`choice-${item.answer_id}`}
                            disabled={
                              isStudent
                                ? true
                                : pageState.selectedCount == 3 &&
                                  !item.choice_flg &&
                                  true
                            }
                            checked={item.choice_flg}
                          />
                          <label
                            className={`btn btn-outline d-flex p-7 bg-light align-items-center mb-10 w-100`}
                            htmlFor={`choice-${item.answer_id}`}
                            style={{ minHeight: '170px', maxHeight: '170px' }}
                          >
                            <div className="symbol symbol-70px me-5">
                              <img
                                className="assessment-image"
                                src={
                                  images.company.assessment[
                                    `Q${item.questionnaire_id}_${item.answer_id}`
                                  ]
                                }
                              />
                            </div>
                            <div className="d-flex just-content-between flex-column">
                              <div className="d-flex flex-column text-start">
                                <span className="text-gray-400 text-hover-primary fs-6 fw-bolder">
                                  {item.questionnaire_title}
                                </span>
                                <span className="text-dark fw-bold">
                                  {item.questionnaire_content}
                                </span>
                              </div>

                              <span className="d-block fw-bold text-start w-100 mt-5">
                                <span className="text-gray-400 fw-bolder d-block fs-6 answer">
                                  ご回答
                                </span>
                                <span className="text-dark fw-bolder d-block fs-6 mb-2 answer">
                                  {item.questionnaire_answer}
                                </span>
                              </span>
                            </div>
                          </label>
                        </div>
                      </div>
                    );
                  })}
                </div>
              </div>
            </>
          )}

          {!isStudent && (
            <>
              <h3 className="d-flex flex-column mb-5">
                <div
                  className="d-flex justify-content-between align-items-center"
                  style={{ minHeight: '40px' }}
                >
                  <span className="card-label fw-bolder fs-1 mb-1">
                    回答一覧
                  </span>
                  <span
                    className="card-label text-white fw-bolder fs-3 mb-1 p-3 bg-primary"
                    style={{
                      borderRadius: '0.8rem',
                      opacity: pageState.selectedCount > 0 ? 1 : 0,
                      transition: '0.6s',
                    }}
                  >
                    選択: {pageState.selectedCount}
                  </span>
                </div>

                {description2 && (
                  <span className="text-light-secondary mt-1 fw-bold fs-12">
                    {description2}
                  </span>
                )}
              </h3>
              <div className="card card-rounded card-bordered assessment-card my-10 px-10 py-15">
                <div id="final-review-result" className="row">
                  {note && (
                    <span className="text-light-secondary fw-bolder fs-4 my-5 ">
                      note
                    </span>
                  )}

                  {pageState.selectedQuestionnaires.map((item, i) => {
                    const questionIndex =
                      pageState.selectedQuestionnaires.findIndex(
                        (x) => x.questionnaire_id == item.questionnaire_id
                      );

                    return (
                      <NewAssessmentReviewCard
                        isStudent={isStudent}
                        key={i}
                        item={item}
                        onCheck={checkHandler}
                        onEdit={() =>
                          editAnswerHandler(
                            item.questionnaire_id,
                            questionIndex
                          )
                        }
                        pageState={pageState}
                      />
                    );
                  })}
                </div>
              </div>
            </>
          )}
        </>
      ) : (
        <div id="final-review-result" className="row">
          <h3 className="d-flex flex-column mb-5">
            <span id="" className="card-label fw-bolder fs-1 mb-1">
              {
                pageState.selectedQuestionnaires[editing.questionIndex]
                  .questionnaire_title
              }
            </span>
            <span
              id='<%= "question-content-#{question_index}" %>'
              className="text-light-secondary mt-1 fw-bold fs-12"
            >
              {
                pageState.selectedQuestionnaires[editing.questionIndex]
                  .questionnaire_content
              }
            </span>
          </h3>

          <EditAssessmentAnswer
            editing={editing}
            setEditing={setEditing}
            pageState={pageState}
            setPageState={setPageState}
          />
        </div>
      )}
    </div>
  );
};

export default NewAssessmentReview;
