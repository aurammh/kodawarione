import React from 'react';
import variable from '../../../../assets/stylesheets/_variable.scss';

const PageLoading = ({ isStudent }) => {
  return (
    <div className={`col-12 ${isStudent && 'card card-rounded border'}`}>
      <div
        className="d-flex align-items-center bg-white p-5"
        style={{ minHeight: '100px' }}
      >
        <svg
          className="spinner text-primary"
          viewBox="0 0 50 50"
          style={{ width: '30px', height: '30px', marginRight: '10px' }}
        >
          <circle
            className="path"
            cx="25"
            cy="25"
            r="20"
            fill="none"
            strokeWidth="5"
            style={{ stroke: variable.companyColor }}
          ></circle>
        </svg>{' '}
        <span className="fs-2">取得中...</span>
      </div>
    </div>
  );
};

export default PageLoading;
