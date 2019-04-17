import React, { Component } from "react";


export default class UserOverview extends Component {
  state = {
    selected: null
  };

  constructor(props) {
    super(props);
  }

  render() {
    return (
      <div className="w-100 bg-blue pa5">
        <div className="bg-green h5 flex items-center justify-center b f2">
          USER
        </div>
      </div>
    );
  }
}
