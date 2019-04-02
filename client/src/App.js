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
    store: [],
    cases: []
  };

  constructor() {
    super();
    this.update = this.update.bind(this);
    this.newCase = this.newCase.bind(this);
  }

  newCase(add) {
    this.state.contract.methods.addCase(add).send({from: this.state.accounts[0]}).then(() => {
      this.state.contract.methods.getCases(this.state.accounts[0]).call().then(list => {
        this.setState({
          cases: list,
        });
      });
    });
  }

  update() {
    this.state.web3.eth.getAccounts().then((acc) => {
      // Check if account has changed
      if (this.state.accounts[0] !== acc[0]) {
        this.state.contract.methods.getCases(acc[0]).call().then(list => {
          this.setState({
            cases: list,
            accounts: acc,
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

      await this.setState({ web3, contract: p});
      this.update();

      // Set web3, accounts, and contract to the state, and then proceed with an
      // example of interacting with the contract's methods.

      this.accountInterval = setInterval( () => {
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

  toBytes(s) {
    return this.state.web3.utils.utf8ToHex(s);
  }

  toString(s) {
    return this.state.web3.utils.hexToUtf8(s);
  }

  // getActions = async (id) => {
  //   const { accounts, contract, caseID, web3 } = this.state;
  //
  //   // Stores a given value, 5 by default.
  //   //await contract.methods.set(5).send({ from: accounts[0] });
  //
  //   // Get the value from the contract to prove it worked.
  //
  //   const response = await contract.methods.getActions(id).call();
  //   //web3.eth.contract(Process.abi).at(contract.address).test(caseID);
  //   //await contract.methods.test(caseID).call();
  //
  //   // Update state with the result.
  //   //this.setState({ storageValue: response });
  //   console.log(response);
  //   return response;
  // };

  // getCases = async () => {
  //   const { accounts, contract, caseID, web3, process42 } = this.state;
  //
  //   const response = await contract.methods.getCases().call();
  //   console.log(response);
  //   return response;
  // };

  // setToDone = async (t, caseID) => {
  //   await this.state.contract.methods.fill(t, caseID).send({ from: this.state.accounts[0] });
  // }

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
    return (
      <div className="App">
        <ContractProvider
          value={{
            web3: this.state.web3,
            accounts: this.state.accounts,
            contract: this.state.contract,
            store: this.state.store,
            cases: this.state.cases,
            newCase: this.newCase
          }}
        >
          <CaseOverview/>
        </ContractProvider>
      </div>
    );
  }
}

export default App;
