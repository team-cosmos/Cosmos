// grid.js

var fs = require('fs');
const gridABIJSONString = fs.readFileSync('/path/to/file.json', 'utf8');

var gridABI = eth.contract(gridABIJSONString);
var gridContract = contractAbi.at(contractAddress);
// suppose you want to call a function named myFunction of myContract
var getData = myContract.myFunction.getData(function parameters);
//finally paas this data parameter to send Transaction
web3.eth.sendTransaction({to:Contractaddress, from:Accountaddress, data: getData});