# BA-process42

An implementation of a governmental process in smart contracts hosted on the Ethereum blockchain.
The 'database' is a modification of a node package by Niels Abildgaard: https://www.npmjs.com/package/simple-dumb-server

The project is using Truffle to deploy the contracts, and Ganache to host a local blockchain.
To run the project you need on of the following browsers: Chrome, Firefox, Opera or Brave

Installation guide:

1. install Node.js

- dowload from https://nodejs.org/en/ and follow the installation guide

2. install the Truffle suite (https://truffleframework.com/truffle)

- Open a terminal and run "npm install truffle -g"

3. install Ganache

- download from https://truffleframework.com/ganache and follow the installation guide

4. install MetaMask (https://metamask.io/)

- to install MetaMask you need to have one of the following browsers: Chrome, Firefox, Opera or Brave
- install the browser-plugin from https://metamask.io/ on your browser of choice.



How to run the project:

1. open Ganache and start a local blockchain

- open Ganache
- press 'New Workspace'
- press the 'add project' and choose the truffle-config.js file from the unzipped project
- navigate to the tab server and make sure the settings are as follows:
  - Hostname: 127.0.0.1
  - Port number: 7545
  - Network ID: 5777
- navigate to the tab 'chain'
- change the gas limit to 9721975
- press 'Save Worspace'
- CONGRATZ! Now your local blockchain is up and running!

2. Deploy the contracts

- first we need to set the address of the Appeals Board. Open ganache and copy an address (not the one on index 0, as this is the municipality)
- open the contract RBAC.sol in a text editor (the contract is located in the folder process42/contracts in the unzipped project)
- locate the place where we set the address of the appeals board (it is marked with a comment '// SET YOUR OWN ADDRESS HERE') and replace the existing address by pasting in the one you just copied
- save the file, and close the text editor. Now we are ready to deploy the contracts!
- in the terminal, navigate into the project (make sure you are in the root folder 'process42')
- run the command 'truffle migrate --reset'
- CONGRATZ! Your contracts is now deployed to the local blockchain

3. Start the database

- in the terminal, navigate into the 'database' folder of the project
- run the command 'npm install' (this install all the necessary dependencies)
- once it is done, run the command 'node start' to start the database (this start a server listening on localhost:8888)
- now your local database is up and running

4. Start the front-end application

- open a new terminal window and navigate into the folder 'client' of the project
- in the terminal run the command 'npm install' (this may take a while to install)
- once it is done, run the command 'npm start' (this starts the app on localhost:3000)
- a browser will open, and your front-end is up and running!
- the browser should prompt you to log in on MetaMask. Select 'Import using account seed phrase'
- open Ganache and copy the text beneath 'MNEMONIC'. It should consist of a list of random words
- paste it into 'Wallet Seed' in MetaMask, provide a password and press 'Restore'. Now all the accounts from Ganache has been imported into MetaMask, and you can now act as these accounts.
- refresh the page, and press 'connect' in the MetaMask prompt.
- Now you should be ready to use the app!

MetaMask will automatically use account 0 when you log in. Remember account 0 from Ganache is the municipality and the account you selected as appeals board will be able to act as appeals board. Therefore, you will be presented with the fron-end for the municipality. You can change account in the MetaMask plugin. Use the other addresses from Ganache to create cases from the municipality interface. Once you do this, these accounts will be able to act as citizens, and see their cases in their interface.


The above guide was run successfully on windows (Windows 10 Home v1803) and mac (MacOS Mojave v10.14.4) on 14/05/2019 with the following versions:
- Ganache: v2.0.1
- Truffle: v5.0.6
- Node.js: v8.15.0
- MetaMask: v6.4.1
