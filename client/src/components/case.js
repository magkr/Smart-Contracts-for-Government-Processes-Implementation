import React, { Component } from "react";
import Data from './data.js';
import DataList from './datalist.js';
import "./case.css";

class Case extends Component {

  constructor(props){
    super(props);
    this.update = this.update.bind(this);
    this.getCase = this.getCase.bind(this);

  }

  state = {
    data: [],
    actionslist: [],
    isLoading: false,
  }

  componentDidMount(){
    this.update();
  }

  componentWillReceiveProps(props){
    this.update();
  }

  async update() {
    await this.setState({isLoading: true});
    await this.setState({
      actionslist: await this.props.contractContext.contract.methods.getActions(this.props.selected).call(),
      data: await this.getCase(),
      isLoading: false
    });
  }

  async getCase(){
    const dataLists = await this.props.contractContext.contract.methods.getCase(this.props.selected).call();
    const titles = dataLists['titles'];
    const statuss = dataLists['statuss'];
    const data = titles.map((t,i) => {
      return { 'title': t, 'status': statuss[i] } });
    return data;
  }

  render() {
    return (
      <div className="w-100 flex flex-column items-left justify-around ph5">
        <h2 className="f5 helvetica" ><span className="b">Case ID: </span>{this.props.selected}</h2>
        {this.state.isLoading
          ? <h2 className="ma3 f4 helvetica">Loading...</h2> :
            <div className="w-100 flex justify-center">
              <div className="w-50">
                {this.state.actionslist.map((a) =>
                      <Data key={a} action={a} caseID={this.props.selected} getActions={this.update} contractContext={this.props.contractContext}/>
                  )}
              </div>
                <DataList contractContext={this.props.contractContext} data={this.state.data}/>
            </div>
        }
      </div>
    )
  }

}

export default Case;
