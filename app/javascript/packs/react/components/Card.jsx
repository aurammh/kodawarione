import React from 'react';

const Card = ({ children, style }) => {
  return (
    <div
      className="card card-custom card-stretch gutter-b bg-white"
      style={style}
    >
      {children}
    </div>
  );
};

export default Card;
