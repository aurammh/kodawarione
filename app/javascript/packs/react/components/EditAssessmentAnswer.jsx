import React from 'react';
import EditAssessmentAnswerCard from './EditAssessmentAnswerCard';

const EditAssessmentAnswer = ({
  editing,
  setEditing,
  pageState,
  setPageState,
}) => {
  const radioClickHandler = (answer_id, questionnaire_answer) => {
    const tempDataArr = pageState.selectedQuestionnaires;
    tempDataArr[editing.questionIndex] = {
      ...pageState.selectedQuestionnaires[editing.questionIndex],
      answer_id,
      questionnaire_answer,
    };

    setPageState({
      ...pageState,
      selectedQuestionnaires: tempDataArr,
    });

    setEditing((prev) => ({
      ...prev,
      status: false,
    }));
  };

  return (
    <div>
      <div className="row">
        {editing.selectedQuestionnaire.answer.map((answer, i) => {
          return (
            <EditAssessmentAnswerCard
              key={i}
              pageState={pageState}
              questionnaire={editing.selectedQuestionnaire}
              answer={answer}
              onClick={radioClickHandler}
            />
          );
        })}
      </div>
    </div>
  );
};

export default EditAssessmentAnswer;
