import React, { Component } from "react";
import DataList from "./datalist.js";
import ActionsList from "./actionslist.js";
import ResolutionView from "./resolutionview.js";
import "../css/reset.css";
import "../css/tachyons.min.css";

class Case extends Component {
  constructor(props) {
    super(props);
    this.update = this.update.bind(this);
    this.editData = this.editData.bind(this);
  }

  state = {
    data: [],
    id: null,
    addr: "",
    actions: [],
    isLoading: false,
    titles: []
  };

  componentDidMount() {
    this.update();
  }

  componentWillReceiveProps(props) {
    this.update();
  }

  async update() {
    await this.setState({ isLoading: true });
    const c = await this.props.contractContext.contract.methods
      .cases(this.props.selected)
      .call();

    const res = await this.readData(c.id);

    await this.setState({
      id: c.id,
      addr: await this.props.contractContext.contract.methods
        .addressFromCase(c.id)
        .call(),
      data: res.data,
      actions: res.actions,
      status: c.status,
      isLoading: false
    });
  }

  async readData(id) {
    const data = [];
    const actions = [];
    this.props.contractContext.contract.methods
      .getCase(id)
      .call()
      .then(response => {
        var statuss = response["statuss"];
        var locations = response["locations"];
        var titles = response["titles"];
        var isReady = response["isReady"];
        var phases = response["phases"];
        statuss.forEach((item, idx) => {
          if (isReady[idx]) {
            actions.push(titles[idx]);
          }
          data.push({
            location: locations[idx],
            title: titles[idx],
            status: statuss[idx],
            ready: isReady[idx],
            phase: phases[idx]
          });
        });
      });
    // console.log(actions);
    return { data: data, actions: actions };
  }

  async editData(d) {
    this.state.actions.push(d.title);
    this.setState({
      actions: this.state.actions
    });
  }

  adminInterface() {
    return (
      <div className="w-100 flex justify-center">
        <DataList
          contractContext={this.props.contractContext}
          data={this.state.data}
          editData={this.editData}
          update={this.update}
        />
        <ActionsList
          contractContext={this.props.contractContext}
          actions={this.state.actions}
          selected={this.props.selected}
          update={this.update}
        />
      </div>
    );
  }

  render() {
    return (
      <div className="w-100 flex flex-column items-left justify-around ph5">
        <h2 className="f4 helvetica tl pa2 mt2 mr2">
          <span className="b">Case ID: </span>
          {this.state.id}
        </h2>
        <h2 className="f4 helvetica tl pa2 mt2 mr2">
          <span className="b">Address: </span>
          {this.state.addr}
        </h2>
        <h2 className="f4 helvetica tl pa2 mt2 mr2">
          <span className="b">Status: </span>
          {this.state.status}
        </h2>
        {this.state.isLoading ? (
          <h2 className="ma3 f4 helvetica">Loading...</h2>
        ) : this.props.contractContext.isOwner ? (
          this.adminInterface()
        ) : null}
        <ResolutionView contractContext={this.props.contractContext} />
      </div>
    );
  }
}

export default Case;
