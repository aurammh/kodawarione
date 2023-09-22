import React from 'react';
import ReactQuill from 'react-quill';

import { images } from '../assets/index';

const NewAssessmentConfirm = ({
  title,
  description1,
  description2,
  onClick1,
  isCommentEditable,
  pageState,
  setPageState,
}) => {
  // Comment Change Handler
  const handleChange = (content, delta, source, editor, questionIndex) => {
    const tempDataArr = pageState.selectedQuestionnaires;
    tempDataArr[questionIndex] = {
      ...pageState.selectedQuestionnaires[questionIndex],
      comment: content,
      empty: editor.getText().length > 1 ? false : true,
    };

    setPageState({
      ...pageState,
      selectedQuestionnaires: tempDataArr,
      confirmBtnDisable: editor.getText().length > 1 ? false : true,
    });
  };

  const onClick1Handler = () => {
    onClick1 && onClick1();
  };

  return (
    <div className="fv-row">
      <div className="d-flex justify-content-between">
        <h3 className="d-flex flex-column mb-5">
          <div
            className="d-flex justify-content-between align-items-center"
            style={{ minHeight: '40px' }}
          >
            <span className="card-label fw-bolder fs-1 mb-1">{title}</span>
          </div>
          {description1 && (
            <span className="text-light-secondary mt-1 fw-bold fs-12">
              {description1}
            </span>
          )}
          {description2 && (
            <span className="text-light-secondary mt-1 fw-bold fs-12">
              {description2}
            </span>
          )}
        </h3>

        {!pageState.editStatus &&
          pageState.route == 'edit' &&
          pageState.update_permission && (
            <div>
              <button
                id="save"
                className="btn btn-primary font-weight-bold py-2 px-6"
                style={{
                  marginLeft: '20px',
                  opacity: pageState.selectedCount == 3 ? 1 : 0,
                  transition: '0.6s',
                }}
                onClick={onClick1Handler}
              >
                再選択する
              </button>
            </div>
          )}
      </div>

      <div id="final-review-result" className="row">
        <div>
          {pageState.selectedQuestionnaires
            .filter((f) => f.choice_flg)
            .map((item, i) => {
              const questionIndex = pageState.selectedQuestionnaires.findIndex(
                (x) => x.questionnaire_id == item.questionnaire_id
              );

              return (
                <div
                  className="card card-rounded card-bordered assessment-card mb-12"
                  key={i}
                >
                  <div className="card-body pt-9 pb-0">
                    <div className="d-flex flex-wrap flex-sm-nowrap">
                      <div className="d-flex flex-center flex-shrink-0 rounded w-100px h-100px w-lg-150px h-lg-150px me-7 mb-4 mr-5">
                        <img
                          src={
                            images.company.assessment[
                              `Q${item.questionnaire_id}_${item.answer_id}`
                            ]
                          }
                          className="assessment-image"
                          alt="alt"
                        />
                      </div>

                      <div className="flex-grow-1 d-flex align-items-center">
                        <div className="d-flex justify-content-between align-items-start flex-wrap mb-2">
                          <div className="d-flex flex-column">
                            <div className="d-flex align-items-center mb-1">
                              <div
                                href="#"
                                className="text-gray-800 text-hover-primary fs-1 fw-bolder me-3"
                              >
                                {item.questionnaire_title}
                              </div>
                            </div>

                            <div className="d-flex flex-wrap fw-bold mb-4 fs-6 text-light-secondary">
                              {item.questionnaire_content}
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>

                    <div className="separator mt-6 mb-8"></div>

                    <div className="timeline">
                      <div className="timeline-item">
                        <div className="timeline-line w-40px"></div>
                        <div className="timeline-icon symbol symbol-circle symbol-40px">
                          <div className="symbol-label bg-light">
                            <span className="svg-icon svg-icon-muted svg-icon-2x">
                              <svg
                                xmlns="http://www.w3.org/2000/svg"
                                width="24"
                                height="24"
                                viewBox="0 0 24 24"
                                fill="none"
                              >
                                <path
                                  opacity="0.3"
                                  d="M20.5543 4.37824L12.1798 2.02473C12.0626 1.99176 11.9376 1.99176 11.8203 2.02473L3.44572 4.37824C3.18118 4.45258 3 4.6807 3 4.93945V13.569C3 14.6914 3.48509 15.8404 4.4417 16.984C5.17231 17.8575 6.18314 18.7345 7.446 19.5909C9.56752 21.0295 11.6566 21.912 11.7445 21.9488C11.8258 21.9829 11.9129 22 12.0001 22C12.0872 22 12.1744 21.983 12.2557 21.9488C12.3435 21.912 14.4326 21.0295 16.5541 19.5909C17.8169 18.7345 18.8277 17.8575 19.5584 16.984C20.515 15.8404 21 14.6914 21 13.569V4.93945C21 4.6807 20.8189 4.45258 20.5543 4.37824Z"
                                  fill="black"
                                />
                                <path
                                  d="M10.5606 11.3042L9.57283 10.3018C9.28174 10.0065 8.80522 10.0065 8.51412 10.3018C8.22897 10.5912 8.22897 11.0559 8.51412 11.3452L10.4182 13.2773C10.8099 13.6747 11.451 13.6747 11.8427 13.2773L15.4859 9.58051C15.771 9.29117 15.771 8.82648 15.4859 8.53714C15.1948 8.24176 14.7183 8.24176 14.4272 8.53714L11.7002 11.3042C11.3869 11.6221 10.874 11.6221 10.5606 11.3042Z"
                                  fill="black"
                                />
                              </svg>
                            </span>
                            {/* <span className="svg-icon svg-icon-2 svg-icon-gray-500">
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
                            </span> */}
                          </div>
                        </div>

                        <div className="timeline-content mb-10 mt-n1">
                          <div className="pe-3 mb-5">
                            <div className="fs-5 fw-bold mb-2">理由</div>

                            <div className="d-flex align-items-center mt-1 fs-6">
                              <div className="text-muted me-2 fs-7">
                                {/* {item.questionnaire_content} */}
                              </div>
                            </div>
                          </div>

                          <div className="overflow-auto pb-5">
                            <div className="notice d-flex bg-light-primary rounded border-primary border border-dashed min-w-lg-600px flex-shrink-0 p-6">
                              <span className="svg-icon svg-icon-2tx svg-icon-primary me-4">
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

                              <div className="d-flex flex-stack flex-grow-1 flex-wrap flex-md-nowrap">
                                <div className="mb-3 mb-md-0 fw-bold">
                                  <h4 className="text-gray-900 fw-bolder text-break">
                                    {item.questionnaire_answer}
                                  </h4>
                                  <div className="fs-6 text-gray-700 pe-7"></div>
                                </div>
                              </div>
                            </div>
                          </div>
                        </div>
                      </div>

                      <div className="timeline-item">
                        <div className="timeline-line w-40px"></div>

                        <div className="timeline-icon symbol symbol-circle symbol-40px">
                          <div className="symbol-label bg-light">
                            <span className="svg-icon svg-icon-2 svg-icon-gray-500">
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
                          </div>
                        </div>

                        <div className="timeline-content mb-10 mt-n1">
                          <div className="pe-3 mb-5">
                            <div className="fs-5 fw-bold mb-2">コメント</div>
                          </div>

                          {isCommentEditable ? (
                            <div className="overflow-auto pb-5">
                              <div className="notice d-flex min-w-lg-600px flex-shrink-0">
                                <div
                                  className="mb-3 fw-bold app"
                                  style={{ marginLeft: 0, marginRight: 0 }}
                                >
                                  <ReactQuill
                                    modules={{
                                      toolbar: [
                                        [
                                          { header: '1' },
                                          { header: '2' },
                                          { font: [] },
                                        ],
                                        [{ size: [] }],
                                        [
                                          'bold',
                                          'italic',
                                          'underline',
                                          // 'strike',
                                          // 'blockquote',
                                        ],
                                        [
                                          { list: 'ordered' },
                                          { list: 'bullet' },
                                          { indent: '-1' },
                                          { indent: '+1' },
                                        ],
                                        // ['link', 'image', 'video'],
                                        ['clean'],
                                      ],
                                      clipboard: {
                                        matchVisual: false,
                                      },
                                    }}
                                    defaultValue={item.comment}
                                    theme="snow"
                                    value={item.comment}
                                    onChange={(
                                      content,
                                      delta,
                                      source,
                                      editor
                                    ) =>
                                      handleChange(
                                        content,
                                        delta,
                                        source,
                                        editor,
                                        questionIndex
                                      )
                                    }
                                    placeholder="コメントを記入してください"
                                    bounds={'.app'}
                                  />
                                </div>
                              </div>
                              {item.empty && (
                                <div
                                  className="fs-6 text-danger"
                                  style={{ marginLeft: 20 }}
                                >
                                  入ってください
                                </div>
                              )}
                            </div>
                          ) : (
                            <div className="overflow-auto pb-5">
                              <div className="notice d-flex bg-light-primary rounded border-primary border border-dashed min-w-lg-600px flex-shrink-0 p-6">
                                <span className="svg-icon svg-icon-2tx svg-icon-primary me-4">
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
                                <div className="d-flex flex-stack flex-grow-1 flex-wrap flex-md-nowrap">
                                  <div className="mb-3 mb-md-0 fw-bold">
                                    <h4 className="text-gray-900 fw-bolder text-break">
                                      <ReactQuill
                                        value={item.comment}
                                        readOnly={true}
                                        theme={'bubble'}
                                      />
                                    </h4>
                                    <div className="fs-6 text-gray-700 pe-7"></div>
                                  </div>
                                </div>
                              </div>
                            </div>
                          )}
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              );
            })}
        </div>
      </div>
    </div>
  );
};

NewAssessmentConfirm.defaultProps = {
  isCommentEditable: true,
  isConfirmPage: false,
};

export default NewAssessmentConfirm;
