# BA-process42

This is a project to implement a governmental process using smart contracts on a blockchain. We will be using the Ethereum network.

We are using Truffle and Ganache for developing and deploying our contracts.

We are using Infura to connect to the Ethereum network. Therefore, it is required to add a .env file, specifying `MNEMONIC` and `INFURA_API_KEY`, in order to connect and deploy i.e. to the kovan test-network

Deploy the contract to a network specified in the truffle-config.js (it uses ganache as the default):
`truffle migrate [--network kovan]`

Interact with the contract with the truffle console:
`truffle console [--network kovan]`
or interact with the contract by editing and running the script.js file:
`truffle exec script.js [--network kovan]`

Our client-side web-application is connecting to Ethereum using MetaMask. When using the application use MetaMask to change the account or the network it should connect to (i.e. local ganache or kovan).

We use lite-server as the development web server, to automatically refresh the application in the browser when making changes. Fire up the server with:
`npm run dev`
