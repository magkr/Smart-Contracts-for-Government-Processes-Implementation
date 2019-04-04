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
    this.submitData = this.submitData.bind(this);
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

    await this.readData(c.id).then(async (res) => {
      return res;
    }).then(async res => {
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
    });
  }

  async submitData(action, value) {
    let hash = this.props.contractContext.web3.utils.sha3(value);
    console.log(hash);
    await this.props.contractContext.contract.methods
      .fillData(action, this.state.id, hash)
      .send({from: this.props.contractContext.accounts[0]}).catch(error => {console.log("failed to submit data to blockchain"); return error; });
    await this.update().then(() => {
      this.state.data.forEach(async d => {
        if (d.title === action) {
          await this.props.contractContext.storeAPI
            .saveData(action, this.state.id, value, hash, d.id).then(() => {return;})
            .catch(error => {
              console.log(`failed to submit data to database!!: ` + { action: action, caseid: this.state.id, value: value, hash: hash, id: d.id });
            });
        }
      })
    });
  };

  async readData(id) {
    const data = [];
    const actions = [];
    const values = [];
    const res = await this.props.contractContext.contract.methods
      .getCase(id)
      .call()
      .then(response => {
        var json = JSON.stringify(response);
        console.log(json);
        var statuss = response["statuss"]; // JSON.STRINGIFY!!!
        var ids = response["ids"];
        var titles = response["titles"];
        var isReady = response["isReady"];
        var phases = response["phases"];
        statuss.forEach((item, idx) => {
          if (isReady[idx]) {
            actions.push(titles[idx]);
          }
          data.push({
            id: ids[idx],
            title: titles[idx],
            status: statuss[idx],
            ready: isReady[idx],
            phase: phases[idx]
          });
        });
        return response;
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
          submitData={this.submitData}
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
