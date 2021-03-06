import React, { Component } from "react";
import Process42 from "./contracts/Process42.json";
import CaseOverview from "./components/caseoverview.js";
import getWeb3 from "./utils/getWeb3";
import { ContractProvider } from "./utils/contractcontext.js";
import { saveData } from "./utils/store.js";

import "./App.css";

class App extends Component {
  state = {
    web3: null,
    accounts: [],
    contract: null,
    cases: {},
    role: -1
  };

  constructor() {
    super();
    this.update = this.update.bind(this);
    this.newCase = this.newCase.bind(this);
    this.appeal = this.appeal.bind(this);
    this.fetchCases = this.fetchCases.bind(this);
    this.markData = this.markData.bind(this);
    this.caseData = this.caseData.bind(this);
    this.submitData = this.submitData.bind(this);
    this.submitDatas = this.submitDatas.bind(this);

    this.handlePayment = this.handlePayment.bind(this);
    this.redo = this.redo.bind(this);
    this.ratify = this.ratify.bind(this);
  }

  fetchCases() {
    this.getCases(this.state.accounts[0], this.state.role).then(list => {
      this.setState({
        cases: list
      });
    });
  }

  appeal(r) {
    this.state.contract.methods
      .appeal(r.title, r.caseID)
      .send({ from: this.state.accounts[0] })
      .then(() => {
        this.fetchCases();
      });
  }

  async newCase(add) {
    this.state.contract.methods
      .addCase(add)
      .send({ from: this.state.accounts[0] })
      .then(() => {
        this.fetchCases();
      });
  }

  async markData(title, caseID) {
    await this.state.contract.methods
      .markData(title, caseID)
      .send({ from: this.state.accounts[0] })
      .then(() => {
        this.fetchCases();
      });
  }

  async submitData(action, caseId, value) {
    let hash = this.state.web3.utils.sha3(value);
    await this.state.contract.methods
      .fillData(action, caseId, hash)
      .send({ from: this.state.accounts[0] })
      .then(async transaction => {
        const newData = await transaction.events.NewData;
        if (newData) {
          const bcData = newData.returnValues;
          await saveData(
            bcData.title,
            bcData.caseID,
            value,
            bcData.dataHash,
            bcData.location
          ).catch(error => {
            console.log(`ERROR: save data to database failed`);
          });
        }
      })
      .catch(error => {
        console.log("ERROR: submit data to blockchain failed");
        console.log(error);
        return error;
      });
    await this.fetchCases();
  }

  async submitDatas(actions, caseId, values) {
    var hashes = [];
    for (var i = 0; i < actions.length; i++) {
      hashes.push(this.state.web3.utils.sha3(values[i]));
    }
    await this.state.contract.methods
      .fillDatas(actions, caseId, hashes)
      .send({ from: this.state.accounts[0] })
      .then(async transaction => {
        const events = await transaction.events.NewData;
        if (events) {
          events.forEach(async (e, i) => {
            const bcData = e.returnValues;
            await saveData(
              bcData.title,
              bcData.caseID,
              values[i],
              bcData.dataHash,
              bcData.location
            ).catch(error => {
              console.log(`ERROR: save data to database failed`);
            });
          });
        }
      })
      .catch(error => {
        console.log("ERROR: submit data to blockchain failed");
        return error;
      });
    await this.fetchCases();
  }

  async handlePayment(caseId, value) {
    let money = this.state.web3.utils.toWei(value, "ether");
    await this.state.contract.methods
      .sendEther(caseId)
      .send({ from: this.state.accounts[0], value: money });
    await this.fetchCases();
  }

  async caseData(c) {
    const actions = [];
    const phaseStruct = {};
    const datalist = [];
    var marked = false;
    await this.state.contract.methods
      .getCase(c.id)
      .call()
      .then(data => {
        data["phases"].forEach(async (phase, idx) => {
          var d = {
            caseID: c.id,
            id: data["ids"][idx],
            hash: data["dataHashes"][idx],
            title: data["titles"][idx],
            status: data["statuss"][idx],
            ready: data["isReady"][idx],
            phase: data["phases"][idx],
            type: data["types"][idx]
          };
          if (!phaseStruct[phase]) phaseStruct[phase] = [];
          phaseStruct[phase].push(d);
          datalist.push(d);
          if (d.status === "3") marked = true;
          if (d.ready) {
            actions.push(d);
          }
        });
      });
    return {
      datalist: datalist,
      data: phaseStruct,
      actions: actions,
      marked: marked
    };
  }

  async role(account) {
    if (
      await this.state.contract.methods
        .hasRole(account, "citizen")
        .call({ from: account })
    )
      return 0;
    if (
      await this.state.contract.methods
        .hasRole(account, "municipality")
        .call({ from: account })
    )
      return 1;
    if (
      await this.state.contract.methods
        .hasRole(account, "appealsboard")
        .call({ from: account })
    )
      return 2;

    return -1;
  }

  async getCases(account, role) {
    if (role === -1) return {};
    if (role === 0)
      return await this.state.contract.methods
        .myCases()
        .call({ from: account });
    var list = await this.state.contract.methods
      .allCases()
      .call({ from: account });
    if (role === 1) return list;
    var ids = [];
    var stss = [];
    list.sts.map((st, idx) => {
      if (st === "2") {
        ids.push(list.ids[idx]);
        stss.push(st);
      }
    });
    return { ids, sts: stss };
  }

  async ratify(id) {
    await this.state.contract.methods
      .ratify(id)
      .send({ from: this.state.accounts[0] });
    await this.fetchCases();
  }

  async redo(id) {
    await this.state.contract.methods
      .redo(id)
      .send({ from: this.state.accounts[0] });
    await this.fetchCases();
  }

  update() {
    if (!this.state.web3 || !this.state.contract) return;
    this.state.web3.eth.getAccounts().then(async acc => {
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

      const deployedNetwork = Process42.networks[networkId];
      const p = new web3.eth.Contract(
        Process42.abi,
        deployedNetwork && deployedNetwork.address
      );

      await this.setState({ web3, accounts: accounts, contract: p });
      await this.setState({ role: await this.role(accounts[0]) });
      this.fetchCases();

      // Set web3, accounts, and contract to the state, and then proceed with an
      // example of interacting with the contract's methods.

      this.accountInterval = setInterval(() => {
        this.update();
        // Call a function to update the UI with the new account
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
    if (!this.state.web3 || !this.state.contract || !this.state.accounts) {
      return (
        <div className="helvetica tc pa4">
          Loader Web3, kontoer, og kontrakt...
        </div>
      );
    } else if (this.state.role === -1) {
      return (
        <div className="helvetica tc pa4">
          'Velkommen til Process 42 hos Syddjurs Kommunes. Din konto er ukendt
          og kan ikke udføre nogle handlinger.'
        </div>
      );
    } else {
      return (
        <div className="App">
          <ContractProvider
            value={{
              contract: this.state.contract,
              web3: this.state.web3,
              accounts: this.state.accounts,
              cases: this.state.cases,
              newCase: this.newCase,
              appeal: this.appeal,
              role: this.state.role,
              markData: this.markData,
              caseData: this.caseData,
              submitData: this.submitData,
              submitDatas: this.submitDatas,
              handlePayment: this.handlePayment,
              redo: this.redo,
              ratify: this.ratify
            }}
          >
            <CaseOverview
              account={this.state.accounts[0]}
              cases={this.state.cases}
              role={this.state.role}
            />
          </ContractProvider>
        </div>
      );
    }
  }
}

export default App;
