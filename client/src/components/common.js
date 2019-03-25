
import React from 'react';

export const ActionInput = (updateValue, fillData) => (
  <div>
    <input className="helvetica w-80" type="text" onChange={(e) => updateValue(e)}/>
    <button className="helvetica w-20 f6 ml3 br1 ba bg-white" onClick={(e) => fillData()}>Submit</button>
  </div>
)
