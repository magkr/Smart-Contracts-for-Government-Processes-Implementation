import React, { Component } from "react";
import { ContractConsumer } from "../utils/contractcontext.js";

class CaseList extends Component {
  constructor(props) {
    super(props);
    this.state = {
      newAddr: "",
      placeholder: "Indtast addresse her"
    };
    this.newCase = this.newCase.bind(this);
  }

  updateAddr = e => {
    this.setState({ placeholder: "Indtast addresse her", newAddr: e.target.value });
  };

  newCase() {
    if (this.props.contractContext.web3.utils.isAddress(this.state.newAddr)) {
      try {
        console.log(32);
        this.props.contractContext.newCase(this.state.newAddr);
        this.setState({
          newAddr: ""
        });
      } catch (err) {}
    } else {
      this.setState({
        newAddr: "",
        placeholder: "Addressen var ikke gyldig"
      });
    }
  }

  async setAppealsBoard() {
    if (this.props.contractContext.web3.utils.isAddress(this.state.newAddr)) {
      try {
        await this.props.contractContext.contract.methods
          .addRole(this.state.newAddr)
          .send({ from: this.props.contractContext.accounts[0] });
        await this.setState({
          newAddr: ""
        });
      } catch (err) {}
    } else {
      this.setState({
        newAddr: "",
        placeholder: "Addressen var ikke gyldig"
      });
    }
  }

  caseStatusBG(status) {
    switch (parseInt(status)) {
      case 1:
        return "bg-washed-red";
      case 2:
        return "bg-washed-blue";
      default:
        return "bg-washed-green";
    }
  }

  caseStatusText(status) {
    switch (parseInt(status)) {
      case 0:
        return "Aktiv";
      case 1:
        return "Under klage";
      case 2:
        return "Hos ankestyrelsen";
      default:
        return "Fejl";
    }
  }

  caseList() {
    const cs = this.props.contractContext.cases;
    if (!cs.ids) return null;
    return cs.ids.map((id, idx) => (
      <li
        key={id}
        className={
          "dt w-100 bb b--black-05 pv2 flex justify-between items-center " +
          this.caseStatusBG(cs.sts[idx])
        }
      >
        <div className="w-two-thirds dtc v-mid pl3">
          <h2 className="f6 ph1 fw4 mt0 mb0 black-60 helvetica">
            <b>Sag:</b> {id}
          </h2>
          <h2 className="f6 ph1 fw4 mt1 mb0 black-60 helvetica ">
            {this.caseStatusText(cs.sts[idx])}
          </h2>
        </div>
        <button
          className="f6 button-reset bg-white ba b--black-10 dim pointer pv1 black-60 helvetica ma2"
          onClick={e => this.props.setSelected(idx)}
        >
          Vis sag
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
          placeholder={this.state.placeholder}
          value={this.state.newAddr}
          onChange={this.updateAddr}
        />
        <button
          className="f6 button-reset bg-white ba b--black-10 dim pointer pv1 black-60 helvetica mv2"
          onClick={this.newCase}
        >
          Tilføj sag
        </button>
      </li>
    );
  }

  setAppealsBoardField() {
    return (
      <li className="dt w-100 bb b--black-05 pa2 flex flex-column justify-between items-start">
        <input
          className="w-100 dtc v-mid helvetica "
          type="text"
          placeholder={this.state.placeholder}
          value={this.state.newAddr}
          onChange={this.updateAddr}
        />
        <button
          className="f6 button-reset bg-white ba b--black-10 dim pointer pv1 black-60 helvetica mv2"
          onClick={() => this.setAppealsBoard()}
        >
          Sæt ny addresse
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
              {context.role === 2 ? this.setAppealsBoardField() : null}
            </ul>
          );
        }}
      </ContractConsumer>
    );
  }
}

export default CaseList;
