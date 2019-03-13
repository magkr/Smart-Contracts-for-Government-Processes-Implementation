import React, { Component } from "react";
import DataList from './datalist.js';
import ActionsList from './actionslist.js';
import '../css/reset.css';
import '../css/tachyons.min.css';


class Case extends Component {

  constructor(props){
    super(props);
    this.update = this.update.bind(this);
    this.getCase = this.getCase.bind(this);

  }

  state = {
    data: [],
    actions: [],
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
      actions: await this.props.contractContext.contract.methods.getActions(this.props.selected).call(),
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
        <h2 className="f4 helvetica tc pa2 mt2 mr2"><span className="b">Case ID: </span>{this.props.selected}</h2>
        {this.state.isLoading
          ? <h2 className="ma3 f4 helvetica">Loading...</h2> :
            <div className="w-100 flex justify-center">
                <ActionsList contractContext={this.props.contractContext} actions={this.state.actions}/>
                <DataList contractContext={this.props.contractContext} data={this.state.data}/>
            </div>
        }
      </div>
    )
  }

}

export default Case;
