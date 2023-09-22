import axios from 'axios';
import React, { useRef } from 'react';
import { SwitchTransition, CSSTransition } from 'react-transition-group';
import {
  NewAssessmentConfirm,
  NewAssessmentReview,
} from '../../../../components';

const EditAssessment = ({ pageState, setPageState }) => {
  const [editing, setEditing] = React.useState({
    status: false,
    selectedQuestionnaire: null,
    questionIndex: null,
  });

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
          url: '/company/assessments/0',
          method: 'PUT',
          headers: {
            'X-CSRF-Token': document
              .getElementsByName('csrf-token')[0]
              .getAttribute('content'),
          },

          data: { company_answer_data: pageState.selectedQuestionnaires },
        });
        setPageState((prev) => ({
          ...prev,
          editStatus: false,
          currentQuestionnaireNo: prev.currentQuestionnaireNo - 1,
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
              {pageState.currentQuestionnaireNo ==
                pageState.selectedQuestionnaires.length && (
                <>
                  <NewAssessmentReview
                    editCounter={pageState.selectedCount}
                    pageState={pageState}
                    setPageState={setPageState}
                    editing={editing}
                    setEditing={setEditing}
                    description2={
                      '選択した項目より、自社の特徴としてよりあてはまる特徴を３つ選択して下さい。'
                    }
                    note=""
                  />
                  {!editing.status && (
                    <div className="d-flex justify-content-end">
                      <button
                        id="save"
                        className="btn btn-primary font-weight-bold py-3 px-7"
                        style={{
                          opacity: pageState.selectedCount == 3 ? 1 : 0,
                          transition: '0.6s',
                          marginBottom: '25px',
                          padding: 10,
                        }}
                        onClick={() => navigate(1)}
                      >
                        確認画面へ
                        <i
                          className="fas fa-arrow-right"
                          style={{ marginLeft: 10 }}
                        ></i>
                      </button>
                    </div>
                  )}
                </>
              )}

              {pageState.currentQuestionnaireNo ==
                pageState.selectedQuestionnaires.length + 1 && (
                <>
                  <NewAssessmentConfirm
                    pageState={pageState}
                    setPageState={setPageState}
                    isEditConfirmPage
                    setEditing={setEditing}
                    title={
                      '選択した「こだわり属性」で自慢できることをお書きください。'
                    }
                  />
                  <div
                    className="d-flex mb-10"
                    style={{
                      justifyContent: 'space-between',
                    }}
                  >
                    <a
                      className="prev-btn btn btn-icon btn-bg-light btn-active-color-primary btn-sm me-1"
                      data-prev='<%= "#{q_index}" %>'
                      data-current='<%= question_index > 8 ? "final-review" : "#{question_index}" %>'
                      onClick={() => navigate(-1)}
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

                    <div className="d-flex">
                      <button
                        ref={btnRef}
                        id="save"
                        className="btn btn-primary font-weight-bold py-3 px-12"
                        onClick={() => updateBtnHandler()}
                        disabled={pageState.confirmBtnDisable ? true : false}
                      >
                        <span className="indicator-label">更新</span>
                        <span className="indicator-progress">
                          取得中...{' '}
                          <span className="spinner-border spinner-border-sm align-middle ms-2"></span>
                        </span>
                      </button>
                    </div>
                  </div>
                </>
              )}
            </>
          ) : (
            <NewAssessmentConfirm
              pageState={pageState}
              isCommentEditable={false}
              title="選択結果"
              description1=""
              description2=""
              onClick1={changeEditStatus}
            />
          )}
        </CSSTransition>
      </SwitchTransition>
    </div>
  );
};

export default EditAssessment;
