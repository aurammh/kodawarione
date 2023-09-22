import React from 'react';

const CardHeader = ({ title, style, textStyle }) => {
  return (
    <div
      className="card-header h-auto border-0 py-3 bg-transparent"
      style={style}
    >
      <div className="card-title pt-5 pb-2">
        <h3 className="card-label">
          <span className="d-block text-dark fw-bolder" style={textStyle}>
            {title}
          </span>
        </h3>
      </div>
    </div>
  );
};

export default CardHeader;
