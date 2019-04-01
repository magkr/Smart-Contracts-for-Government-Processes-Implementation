import React, { Component } from "react";
import DataList from "./datalist.js";
import ActionsList from "./actionslist.js";
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
    isLoading: false
  };

  componentDidMount() {
    this.update();
  }

  componentWillReceiveProps(props) {
    this.update();
  }

  async update() {
    console.log(this.props.selected);
    await this.setState({ isLoading: true });
    const c = await this.props.contractContext.contract.methods
      .cases(this.props.selected)
      .call();
    console.log(c);
    await this.setState({
      actions: await this.props.contractContext.contract.methods
        .getActions(c.id)
        .call(),
      id: c.id,
      addr: await this.props.contractContext.contract.methods
        .addressFromCase(c.id)
        .call(),
      isLoading: false
    });
  }

  async editData(d) {
    this.state.actions.push(d.title);
    this.setState({
      actions: this.state.actions
    });
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
        {this.state.isLoading ? (
          <h2 className="ma3 f4 helvetica">Loading...</h2>
        ) : (
          <div className="w-100 flex justify-center">
            <ActionsList
              contractContext={this.props.contractContext}
              actions={this.state.actions}
              selected={this.props.selected}
              update={this.update}
            />
            <DataList
              contractContext={this.props.contractContext}
              data={this.state.data}
              editData={this.editData}
              update={this.update}
            />
          </div>
        )}
      </div>
    );
  }
}

export default Case;
