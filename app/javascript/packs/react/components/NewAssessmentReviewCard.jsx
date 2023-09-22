import React from 'react';
import { images } from '../assets';

const NewAssessmentReviewCard = ({
  item,
  onCheck,
  onEdit,
  pageState,
  isStudent,
}) => {
  const onCheckHandler = (event, questionnaire_id, answer_id) => {
    onCheck && onCheck(event, questionnaire_id, answer_id);
  };

  const onEditHandler = () => {
    onEdit && onEdit();
  };

  return (
    <div className="col-lg-6">
      <div
        className="d-flex justify-content-center align-items-center position-relative"
        style={{
          opacity: pageState.selectedCount == 3 && !item.choice_flg && 0.4,
          transition: '0.6s',
        }}
      >
        {pageState.editStatus && !isStudent && (
          <div className="position-absolute top-0 end-0  pt-2 px-2">
            <button
              className="prev-btn btn btn-icon btn-bg-light btn-color-primary btn-active-color-primary btn-sm me-1 shadow-sm"
              onClick={(e) => {
                e.preventDefault();
                onEditHandler(item.questionnaire_id);
              }}
              disabled={
                pageState.selectedCount == 3 && !item.choice_flg && true
              }
            >
              <span className="svg-icon svg-icon-3">
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
                  ></path>
                  <path
                    d="M5.574 21.3L3.692 21.928C3.46591 22.0032 3.22334 22.0141 2.99144 21.9594C2.75954 21.9046 2.54744 21.7864 2.3789 21.6179C2.21036 21.4495 2.09202 21.2375 2.03711 21.0056C1.9822 20.7737 1.99289 20.5312 2.06799 20.3051L2.696 18.422L5.574 21.3ZM4.13499 14.105L9.891 19.861L19.245 10.507L13.489 4.75098L4.13499 14.105Z"
                    fill="black"
                  ></path>
                </svg>
              </span>
            </button>
          </div>
        )}

        <input
          type="checkbox"
          className="btn-checkbox"
          onChange={(event) =>
            onCheckHandler(event, item.questionnaire_id, item.answer_id)
          }
          id={`choice-${item.answer_id}`}
          disabled={
            isStudent
              ? true
              : pageState.selectedCount == 3 && !item.choice_flg && true
          }
          checked={item.choice_flg}
        />
        <label
          className={`btn btn-outline d-flex ${
            !isStudent && 'btn-outline-dashed btn-outline-default'
          } p-7 bg-light align-items-center mb-10 w-100`}
          htmlFor={`choice-${item.answer_id}`}
          style={{ minHeight: '220px' }}
        >
          <div className="symbol symbol-100px me-5">
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
              <span className="text-gray-400 fw-bolder d-block fs-4 answer">
                ご回答
              </span>
              <span className="text-dark fw-bolder d-block fs-4 mb-2 answer">
                {item.questionnaire_answer}
              </span>
            </span>
          </div>
        </label>
      </div>
    </div>
  );
};

export default NewAssessmentReviewCard;
