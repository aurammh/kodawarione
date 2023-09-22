import React from 'react';

const AssessmentButton = ({ selectedCount, onClick }) => {
  const radioClickHandler = () => {
    onClick();
  };

  return (
    <div className="d-flex align-items-center">
      <a
        href="#"
        className="prev-btn btn btn-icon btn-bg-light btn-active-color-primary btn-sm me-1"
        data-prev='<%= "#{q_index}" %>'
        data-current='<%= question_index > 8 ? "final-review" : "#{question_index}" %>'
        onClick={(e) => preventBtnHandler(e)}
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

      <button
        id="save"
        className="btn btn-primary font-weight-bold py-2 px-6"
        style={{
          marginLeft: '20px',
          opacity: selectedCount == 3 ? 1 : 0,
          transition: '0.6s',
        }}
        // onClick={() => radioClickHandler(null)}
      >
        確認画面へ
      </button>
    </div>
  );
};

export default AssessmentButton;
