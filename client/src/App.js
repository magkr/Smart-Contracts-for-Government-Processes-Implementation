import React, { Component } from "react";
import Process42 from "./contracts/Process42.json";
import CaseOverview from "./components/caseoverview.js";
import getWeb3 from "./utils/getWeb3";
import { ContractProvider } from "./utils/contractcontext.js";

import "./App.css";

class App extends Component {
  state = {
    web3: null,
    accounts: [],
    contract: null,
    cases: {},
  };

  constructor() {
    super();
    this.update = this.update.bind(this);
    this.newCase = this.newCase.bind(this);
    this.complain = this.complain.bind(this);
    this.fetchCases = this.fetchCases.bind(this);
  }

  fetchCases() {
    this.getCases(this.state.accounts[0], this.state.role)
      .then(list => {
        this.setState({
          cases: list
        });
      });
  }

  complain(r) {
    this.state.contract.methods
      .complain(r.title, r.caseID)
      .send({ from: this.state.accounts[0] })
      .then(() => {
        this.fetchCases();
      });
  }

  newCase(add) {
    this.state.contract.methods
      .addCase(add)
      .send({ from: this.state.accounts[0] })
      .then(() => {
        this.fetchCases();
      });
  }

  async role(account) {
    if (await this.state.contract.methods.hasRole(account, "citizen").call({from: account})) return 0;
    if (await this.state.contract.methods.hasRole(account, "municipality").call({from: account})) return 1;
    if (await this.state.contract.methods.hasRole(account, "council").call({from: account})) return 2;
    return -1;
  }

  async getCases(account, role) {
    if (role === -1) return [];
    if (role === 0) return await this.state.contract.methods.myCases().call({from: account});
    else return await this.state.contract.methods.allCases().call({from: account});
  }

  update() {
    this.state.web3.eth.getAccounts().then(acc => {
      // Check if account has changed
      if (this.state.accounts[0] !== acc[0]) {
        this.role(acc[0]).then(async role => {
          await this.setState({
            cases: await this.getCases(acc[0], role),
            accounts: acc,
            role: role
          });
        });
      }
    });
  }

  componentDidMount = async () => {
    try {
      // Get network provider and web3 instance.
      const web3 = await getWeb3();

      // Use web3 to get the user's accounts.
      const accounts = await web3.eth.getAccounts();

      // Get the contract instance.
      const networkId = await web3.eth.net.getId();

      // const deployedNetwork = Process.networks[networkId];
      // const instance = new web3.eth.Contract(
      //   Process.abi,
      //   deployedNetwork && deployedNetwork.address,
      // );

      const deployedNetwork = Process42.networks[networkId];
      const p = new web3.eth.Contract(
        Process42.abi,
        deployedNetwork && deployedNetwork.address
      );

      await this.setState({ web3, contract: p });
      this.update();

      // Set web3, accounts, and contract to the state, and then proceed with an
      // example of interacting with the contract's methods.

      this.accountInterval = setInterval(() => {
        this.update();
        // Call a function to update the UI with the new account
        // getZombiesByOwner(userAccount)
        // .then(displayZombies);
      }, 100);

    } catch (error) {
      // Catch any errors for any of the above operations.
      alert(
        `Failed to load web3, accounts, or contract. Check console for details.`
      );
      console.error(error);
    }
  };


  render() {
    if (!this.state.web3) {
      return (
        <div className="helvetica tc pa4">
          Loading Web3, accounts, and contract...
        </div>
      );
    }
    if (!this.state.contract || !this.state.accounts) {
      return <div className="helvetica tc pa4">Loading contract...</div>;
    }
    //return null;
    return (
      <div className="App">
        <ContractProvider
          value={{
            web3: this.state.web3,
            accounts: this.state.accounts,
            contract: this.state.contract,
            store: this.state.store,
            cases: this.state.cases,
            newCase: this.newCase,
            complain: this.complain,
            role: this.state.role
          }}
        >
          <CaseOverview />
        </ContractProvider>
      </div>
    );
  }
}

export default App;
