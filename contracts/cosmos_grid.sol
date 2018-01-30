[
    {
        "constant": true,
        "inputs": [
            {
                "name": "energyType",
                "type": "uint16"
            }
        ],
        "name": "getEnergyBalance",
        "outputs": [
            {
                "name": "balance",
                "type": "uint256"
            }
        ],
        "payable": false,
        "stateMutability": "view",
        "type": "function"
    },
    {
        "constant": false,
        "inputs": [
            {
                "name": "user",
                "type": "address"
            }
        ],
        "name": "registerOwner",
        "outputs": [
            {
                "name": "success",
                "type": "bool"
            }
        ],
        "payable": false,
        "stateMutability": "nonpayable",
        "type": "function"
    },
    {
        "constant": true,
        "inputs": [
            {
                "name": "meter",
                "type": "address"
            }
        ],
        "name": "deregisterMeter",
        "outputs": [
            {
                "name": "success",
                "type": "bool"
            }
        ],
        "payable": false,
        "stateMutability": "view",
        "type": "function"
    },
    {
        "constant": false,
        "inputs": [
            {
                "name": "_energyType",
                "type": "uint16"
            },
            {
                "name": "_value",
                "type": "uint256"
            }
        ],
        "name": "listEnergy",
        "outputs": [
            {
                "name": "success",
                "type": "bool"
            }
        ],
        "payable": false,
        "stateMutability": "nonpayable",
        "type": "function"
    },
    {
        "constant": false,
        "inputs": [
            {
                "name": "energyType",
                "type": "uint16"
            },
            {
                "name": "value",
                "type": "uint256"
            }
        ],
        "name": "sendEnergyToGrid",
        "outputs": [
            {
                "name": "success",
                "type": "bool"
            }
        ],
        "payable": false,
        "stateMutability": "nonpayable",
        "type": "function"
    },
    {
        "constant": true,
        "inputs": [],
        "name": "getMeters",
        "outputs": [
            {
                "name": "success",
                "type": "bool"
            },
            {
                "name": "meters",
                "type": "address[]"
            }
        ],
        "payable": false,
        "stateMutability": "view",
        "type": "function"
    },
    {
        "constant": false,
        "inputs": [],
        "name": "kill",
        "outputs": [],
        "payable": false,
        "stateMutability": "nonpayable",
        "type": "function"
    },
    {
        "constant": false,
        "inputs": [
            {
                "name": "_energyType",
                "type": "uint16"
            },
            {
                "name": "_value",
                "type": "uint256"
            }
        ],
        "name": "unlistEnergy",
        "outputs": [
            {
                "name": "success",
                "type": "bool"
            }
        ],
        "payable": false,
        "stateMutability": "nonpayable",
        "type": "function"
    },
    {
        "constant": false,
        "inputs": [
            {
                "name": "_to",
                "type": "address"
            },
            {
                "name": "_energyType",
                "type": "uint16"
            },
            {
                "name": "_value",
                "type": "uint256"
            }
        ],
        "name": "transferListedEnergy",
        "outputs": [
            {
                "name": "success",
                "type": "bool"
            }
        ],
        "payable": false,
        "stateMutability": "nonpayable",
        "type": "function"
    },
    {
        "constant": false,
        "inputs": [
            {
                "name": "depot",
                "type": "address"
            },
            {
                "name": "energyType",
                "type": "uint16"
            },
            {
                "name": "price",
                "type": "uint256"
            },
            {
                "name": "quantity",
                "type": "uint256"
            },
            {
                "name": "begin",
                "type": "uint256"
            },
            {
                "name": "end",
                "type": "uint256"
            }
        ],
        "name": "requestStorage",
        "outputs": [
            {
                "name": "success",
                "type": "bool"
            }
        ],
        "payable": false,
        "stateMutability": "nonpayable",
        "type": "function"
    },
    {
        "constant": true,
        "inputs": [],
        "name": "storageRequestId",
        "outputs": [
            {
                "name": "",
                "type": "uint256"
            }
        ],
        "payable": false,
        "stateMutability": "view",
        "type": "function"
    },
    {
        "constant": true,
        "inputs": [],
        "name": "getOwner",
        "outputs": [
            {
                "name": "success",
                "type": "bool"
            },
            {
                "name": "user",
                "type": "address"
            }
        ],
        "payable": false,
        "stateMutability": "view",
        "type": "function"
    },
    {
        "constant": false,
        "inputs": [
            {
                "name": "id",
                "type": "uint256"
            },
            {
                "name": "accept",
                "type": "bool"
            }
        ],
        "name": "respondToStorageRequest",
        "outputs": [
            {
                "name": "success",
                "type": "bool"
            }
        ],
        "payable": false,
        "stateMutability": "nonpayable",
        "type": "function"
    },
    {
        "constant": true,
        "inputs": [
            {
                "name": "energyType",
                "type": "uint16"
            }
        ],
        "name": "getListedEnergy",
        "outputs": [
            {
                "name": "listed",
                "type": "uint256"
            }
        ],
        "payable": false,
        "stateMutability": "view",
        "type": "function"
    },
    {
        "constant": false,
        "inputs": [
            {
                "name": "newOwner",
                "type": "address"
            },
            {
                "name": "meter",
                "type": "address"
            }
        ],
        "name": "transferMeter",
        "outputs": [
            {
                "name": "success",
                "type": "bool"
            }
        ],
        "payable": false,
        "stateMutability": "nonpayable",
        "type": "function"
    },
    {
        "constant": false,
        "inputs": [
            {
                "name": "id",
                "type": "uint256"
            }
        ],
        "name": "deleteStorageRequest",
        "outputs": [
            {
                "name": "success",
                "type": "bool"
            }
        ],
        "payable": false,
        "stateMutability": "nonpayable",
        "type": "function"
    },
    {
        "constant": false,
        "inputs": [
            {
                "name": "_to",
                "type": "address"
            },
            {
                "name": "_energyType",
                "type": "uint16"
            },
            {
                "name": "_value",
                "type": "uint256"
            }
        ],
        "name": "transferEnergyBalance",
        "outputs": [
            {
                "name": "success",
                "type": "bool"
            }
        ],
        "payable": false,
        "stateMutability": "nonpayable",
        "type": "function"
    },
    {
        "constant": true,
        "inputs": [
            {
                "name": "energyType",
                "type": "uint16"
            }
        ],
        "name": "getTotalEnergyType",
        "outputs": [
            {
                "name": "listed",
                "type": "uint256"
            }
        ],
        "payable": false,
        "stateMutability": "view",
        "type": "function"
    },
    {
        "constant": false,
        "inputs": [
            {
                "name": "newAdmin",
                "type": "address"
            }
        ],
        "name": "transferOwnership",
        "outputs": [
            {
                "name": "success",
                "type": "bool"
            }
        ],
        "payable": false,
        "stateMutability": "nonpayable",
        "type": "function"
    },
    {
        "inputs": [],
        "payable": false,
        "stateMutability": "nonpayable",
        "type": "constructor"
    }
]