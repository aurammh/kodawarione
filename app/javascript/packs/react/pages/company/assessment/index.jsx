import React from 'react';
import ReactDOM from 'react-dom';
import axios from 'axios';
import { NewAssessment, EditAssessment } from './components';
import { CSSTransition, SwitchTransition } from 'react-transition-group';
import { PageLoading } from '../../../components';

const CompanyAssessment = () => {
  // State
  const [questionnaireData, setQuestionnaireData] = React.useState([]);
  const [pageState, setPageState] = React.useState({
    currentQuestionnaireNo: null,
    selectedCount: null,
    selectedQuestionnaires: [],
    route: 'loading', // there will be 3 routes ( "new" | "edit" | "loading" )
    editStatus: false,
  });

  React.useEffect(() => {
    const init = async () => {
      let route = pageState.route;
      try {
        const response = await axios.get('questionnaire');
        setQuestionnaireData(response.data.questionnaires_data);

        if (response.data.company_assessment.length == 0) {
          route = 'new';
        }
        if (response.data.company_assessment.length > 0) {
          route = 'edit';
        }

        const selectedCount = response.data.company_assessment.filter(
          (item) => item.choice_flg
        ).length;

        setTimeout(() => {
          setPageState({
            ...pageState,
            currentQuestionnaireNo: response.data.company_assessment.length,
            selectedQuestionnaires: response.data.company_assessment,
            questionnaireData: response.data.questionnaires_data,
            selectedCount,
            route,
            create_permission: response.data.create_permission,
            update_permission: response.data.update_permission,
          });
        }, 1000);
      } catch (error) {
        console.warn(error);
      }
    };

    init();
  }, []);

  const renderAssessment = () => {
    if (pageState.route == 'new') {
      return (
        <NewAssessment
          pageState={pageState}
          setPageState={setPageState}
          questionnaireData={questionnaireData}
        />
      );
    }

    if (pageState.route == 'edit') {
      return (
        <EditAssessment pageState={pageState} setPageState={setPageState} />
      );
    }

    return <PageLoading />;
  };

  return (
    <SwitchTransition mode="out-in">
      <CSSTransition
        key={pageState.route}
        addEndListener={(node, done) => {
          node.addEventListener('transitionend', done, false);
        }}
        classNames="fade"
      >
        {renderAssessment()}
      </CSSTransition>
    </SwitchTransition>
  );
};

document.addEventListener('turbolinks:load', () => {
  const app = document.getElementById('company-assessment');
  app && ReactDOM.render(<CompanyAssessment />, app);
});
