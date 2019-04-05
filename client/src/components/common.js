import React from "react";

export const ActionInput = (handleSubmit) => (
  <div>
    <input
      className="helvetica w-80"
      type="text"
    />
    <button
      className="helvetica w-20 f6 ml3 br1 ba bg-white"
      onClick={handleSubmit}
    >
      Submit
    </button>
  </div>
);
