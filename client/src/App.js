import React, { Component } from "react";
import Process from "./contracts/Process.json";
import getWeb3 from "./utils/getWeb3";

import "./App.css";

class App extends Component {
  state = { storageValue: [], web3: null, accounts: null, contract: null, caseID: 0 };

  componentDidMount = async () => {
    try {
      // Get network provider and web3 instance.
      const web3 = await getWeb3();

      // Use web3 to get the user's accounts.
      const accounts = await web3.eth.getAccounts();

      // Get the contract instance.
      const networkId = await web3.eth.net.getId();
      const deployedNetwork = Process.networks[networkId];
      const instance = new web3.eth.Contract(
        Process.abi,
        deployedNetwork && deployedNetwork.address,
      );

      // Set web3, accounts, and contract to the state, and then proceed with an
      // example of interacting with the contract's methods.
      this.setState({ web3, accounts, contract: instance }, this.runExample);
    } catch (error) {
      // Catch any errors for any of the above operations.
      alert(
        `Failed to load web3, accounts, or contract. Check console for details.`,
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

  runExample = async () => {
    const { accounts, contract, caseID } = this.state;

    // Stores a given value, 5 by default.
    //await contract.methods.set(5).send({ from: accounts[0] });

    // Get the value from the contract to prove it worked.
    const response = await contract.methods.test(caseID).call();
    console.log(response);

    // Update state with the result.
    this.setState({ storageValue: response });
  };

  finish = async (t) => {
    await this.state.contract.methods.fill(t, this.state.caseID).send({ from: this.state.accounts[0] });
    await this.runExample();
  }

  render() {
    if (!this.state.web3) {
      return <div>Loading Web3, accounts, and contract...</div>;
    }
    return (
      <div className="App">
        <h1>Good to Go!</h1>
        {
          this.state.storageValue.map((title) => <button onClick={ (e) => this.finish(title) }> { this.toString(title) } </button>)
        }
      </div>
    );
  }
}

export default App;
