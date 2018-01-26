// ethereum-setup.js
const ethUtils = require('./ethereum-utils');
const _password = "cosmos";
const _address = "6f753d32768d47b98327e3fb1829b7a62006c71c";

// /* Set up web3 */
// const ethClient = "https://ropsten.infura.io/ynXBPNoUYJ3C4ZDzqjga";
// var Web3 = require('web3');
// web3 = new Web3(new Web3.providers.HttpProvider(ethClient));



// // contract ABIs
// const marketABI = require('../abi/cosmos-market.json');

// // contract addresses 
// const token_addr = "0x0fD0E740B012bB7AA4E48AD6ECDB854345C2463d";
// const grid_addr = "0xd557D9961286711E35cA360Ad86e8033277903c6";
// const market_addr = "0xb24af1f3d5ec84aa14693d114ae94ef542da521f";

// // user addr
// const user_addr = "0x929FFF0071a12d66b9d2A90f8c3A6699551E91e3";

// // market contract instance
// var MarketContract = new web3.eth.Contract(marketABI,market_addr, {
// 	// from: user_addr
// });

// // MarketContract.methods.getSellListingsByType(energyType, from, to, active).call({}, function(err, result){
// // 	if(err) console.log(err);

// // 	console.log(result)
// // });	

// // get number of sellListings
// MarketContract.methods.sellListingId().call({}, function(err, result){
// 	if(err) console.log(err);

// 	for(var i = 0; i < result; i++) {
// 		MarketContract.methods.getSellListing(i).call({}, function(err, result){
// 			if(err) console.log(err);

// 		  // ejse.data('main_file', 'main_dashboard.ejs');

// 			// active
// 			// energyType
// 			// quantity
// 			// seller
// 			// success
// 			// unitPrice


//       // <th>Listing Id</th>
//       // <th>Energy Type</th>
//       // <th>Seller</th>
//       // <th>Price</th>
//       // <th>Quantity</th>
//       // <th>Status</th>

// 			// console.log(result.)

//                       // <tr>
//                       //   <td>Yiorgos Avraamu</td>
//                       //   <td>2012/01/01</td>
//                       //   <td>Member</td>
//                       //   <td>
//                       //     <span class="badge badge-success">Active</span>
//                       //   </td>
//                       // </tr>
//                       console.log(result)
// 			$('table#sell_listing tbody').append("<tr><td>" + result.id + "</td><td>" + result.energyType + "</td><td>" + result.seller + "</td><th>" + result.unitPrice + "</th><th>" + result.quantity + "</th><td><span class='badge badge-success'>Active</span></td></tr>");

// 		});
// 	}

// });



// const ethTx = require('ethereumjs-tx');

// const txParams = {
//   nonce: '0x6', // Replace by nonce for your account on geth node
//   gasPrice: '0x09184e72a000', 
//   gasLimit: '0x30000',
//   to: '0xfa3caabc8eefec2b5e2895e5afbf79379e7268a7', 
//   value: '0x00'
// };
// // Transaction is created
// const tx = new ethTx(txParams);


// /* Set up account */
// var wallet = ethUtils.createWallet();
// console.log(wallet)
