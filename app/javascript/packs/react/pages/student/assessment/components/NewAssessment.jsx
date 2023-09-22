import React from 'react';
import { CSSTransition, SwitchTransition } from 'react-transition-group';
import NewAssessmentForm from './NewAssessmentForm';

const NewAssessment = ({ pageState, questionnaireData, setPageState }) => {
  const [route, setRoute] = React.useState('first');

  const startQuestionnaireHandler = () => {
    setPageState({
      ...pageState,
      currentQuestionnaireNo: 0,
    });
    setRoute('new');
  };

  const render = () => {
    if (route == 'first') {
      return (
        <div
          id="start-section"
          className="card card-custom gutter-b assessment-card"
        >
          <div className="card-body d-flex p-0">
            <div className="flex-grow-1 p-12 card-rounded bgi-no-repeat d-flex flex-column justify-content-center align-items-start">
              <h4 className="text-primary font-weight-bolder m-0 fs-1">
                企業選びのこだわり
              </h4>
              <p className="text-dark-50 my-5 font-weight-bold fs-3">
                「開始」ボタンを押して回答を始めてください。
              </p>
              <button
                id="start-questionnaire"
                className="btn btn-primary font-weight-bold py-2 px-6"
                onClick={startQuestionnaireHandler}
              >
                開始
              </button>
            </div>
          </div>
        </div>
      );
    }

    if (route == 'new') {
      return (
        <NewAssessmentForm
          currentNo={pageState.currentQuestionnaireNo}
          data={questionnaireData}
          pageState={pageState}
          setPageState={setPageState}
        />
      );
    }
  };

  return (
    <SwitchTransition mode="out-in">
      <CSSTransition
        key={route}
        addEndListener={(node, done) => {
          node.addEventListener('transitionend', done, false);
        }}
        classNames="fade"
      >
        <>{render()}</>
      </CSSTransition>
    </SwitchTransition>
  );
};

export default NewAssessment;
