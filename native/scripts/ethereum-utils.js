// ethereum-utils.js

// var keythereum = require("keythereum");
const hdkey = require('ethereumjs-wallet/hdkey');
const Wallet = require('ethereumjs-wallet');


var createWallet = function() {
  const privateKey = hdkey.fromMasterSeed('random')._hdkey._privateKey;
  const wallet = Wallet.fromPrivateKey(privateKey);
  return wallet;
}

// var dumpKeyAsync = function(password) {
//   var kdf = "pbkdf2"; // or "scrypt" to use the scrypt kdf

//   var options = {
//     kdf: "pbkdf2",
//     cipher: "aes-128-ctr",
//     kdfparams: {
//       c: 262144,
//       dklen: 32,
//       prf: "hmac-sha256"
//     }
//   };

//   keythereum.dump(
//     password, newKey.privateKey, 
//     newKey.salt, newKey.iv, options, 
//     function (keyObject) {
//       keythereum.exportToFile(keyObject);
//     });
// }

// var importKeySync = function(address, password) {
//   var datadir = "./";
//   var keyObject = keythereum.importFromFile(address, datadir);
//   return privateKey = keythereum.recover(password, keyObject);
// }

module.exports = {
    createWallet: createWallet
};
