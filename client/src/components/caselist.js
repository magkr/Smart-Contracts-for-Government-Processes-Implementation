import React, { Component } from "react";
import "../css/reset.css";
import "../css/tachyons.min.css";
import { ContractConsumer } from "../utils/contractcontext.js";

class CaseList extends Component {
  constructor(props) {
    super(props);
    this.state = {
      newAddr: ""
    };
    this.newCase = this.newCase.bind(this);
  }

  updateAddr = e => {
    this.setState({ newAddr: e.target.value });
  };

  newCase() {
    try {
      this.props.contractContext.newCase(this.state.newAddr);
      this.setState({
        newAddr: ""
      });
    } catch (err) {}
  }

  setCouncil() {
    try {
      this.props.contractContext.addRole(this.state.newAddr);
      this.setState({
        newAddr: ""
      });
    } catch (err) {}
  }

  caseList() {
    const cs = this.props.contractContext.cases
    if (!cs.ids) return null
    return cs.ids.map((id, idx) => (
      <li
        key={id}
        className="dt w-100 bb b--black-05 pb2 mt2 flex justify-between items-center"
      >
        <div className="w-two-thirds dtc v-mid pl3">
          <h2 className="f6 ph1 fw4 mt0 mb0 black-60 helvetica">
            <b>Case ID:</b> {id}
          </h2>
          <h2 className="f6 ph1 fw4 mt0 mb0 black-60 helvetica">
            <b>Status:</b> {cs.sts[idx]}
          </h2>
        </div>
        <button
          className="f6 button-reset bg-white ba b--black-10 dim pointer pv1 black-60 helvetica ma2"
          onClick={e => this.props.setSelected({id: id, status: cs.sts[idx]})}
        >
          Show case
        </button>
      </li>
    ));
  }

  addCaseField() {
    return (
      <li className="dt w-100 bb b--black-05 pa2 flex flex-column justify-between items-start">
        <input
          className="w-100 dtc v-mid helvetica "
          type="text"
          value={this.state.newAddr}
          onChange={this.updateAddr}
        />
        <button
          className="f6 button-reset bg-white ba b--black-10 dim pointer pv1 black-60 helvetica mv2"
          onClick={this.newCase}
        >
          Add case
        </button>
      </li>
    );
  }

  render() {
    return (
      <ContractConsumer>
        {context => {
          return (
            <ul className="w-100">
              {context.cases ? this.caseList() : null}
              {context.role === 1 ? this.addCaseField() : null}
            </ul>
          );
        }}
      </ContractConsumer>
    );
  }
}

export default CaseList;
