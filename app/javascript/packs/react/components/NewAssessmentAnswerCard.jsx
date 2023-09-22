import React from 'react';
import { images } from '../assets';

const NewAssessmentAnswerCard = ({
  answer,
  onClick,
  pageState,
  questionnaire,
}) => {
  const onClickHandler = (
    questionnaire_id,
    questionnaire_title,
    questionnaire_content,
    answer_id,
    questionnaire_answer
  ) => {
    onClick &&
      onClick(
        questionnaire_id,
        questionnaire_title,
        questionnaire_content,
        answer_id,
        questionnaire_answer
      );
  };

  return (
    <div className="col-lg-6">
      <div
        className="d-flex justify-content-center align-items-center"
        id='<%= "question-#{question_index}-#{answer_index}-block" %>'
      >
        <input
          type="radio"
          className="btn-check"
          name=""
          value=""
          onChange={() => {}}
          checked={pageState.selectedQuestionnaires.find(
            (item) => item.answer_id == answer.id
          )}
        />
        <label
          className="btn btn-outline btn-outline-dashed btn-outline-default p-7 align-items-center mb-10 text-center"
          htmlFor='<%= "question-#{question_index}-#{answer_index}" %>'
          onClick={() =>
            onClickHandler(
              questionnaire.questionnaire_id,
              questionnaire.questionnaire_title,
              questionnaire.questionnaire_content,
              answer.id,
              answer.questionnaire_answer
            )
          }
        >
          <img
            src={
              images.company.assessment[
                `Q${questionnaire.questionnaire_id}_${answer.id}`
              ]
            }
            className="assessment-image"
            alt="alt"
          />
          <span className="d-block fw-bold text-center">
            <span className="text-dark fw-bolder d-block fs-4 mb-2 answer">
              {answer.questionnaire_answer}
            </span>
          </span>
        </label>
      </div>
    </div>
  );
};

export default NewAssessmentAnswerCard;
