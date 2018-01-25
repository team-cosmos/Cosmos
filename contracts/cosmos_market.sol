pragma solidity ^0.4.0;

contract Cosmos {
    function getAddress(uint tag) public view returns (address contractAddr) {}
}

contract CosmosGrid {
     function transferEnergy(address _to, uint256 _value) public {}
}

contract CosmosMarket {

    /** Admin of this contract. */
    address private admin;

    /** Address of main application contract. */
    address private cosmosAddress;

    /** Address of CosmosToken contract. */
    address private tokenAddress;

    /** Address of grid contract. */
    address private gridAddress;

    // uint user_count;
    uint energy_id;

    // address[] public users;
    // mapping (address => uint) public sellMap; // user address -> energy id
    // Energy[] public sellList; // list of Energy for selling
    mapping (uint => Energy) public sellList;
    mapping (address => Energy[]) public userEnergies;
    
    struct Energy {
        uint e_id;
        bytes2 e_type;  // solar: SL, wind: WD, etc
        uint unit_price;
        uint quantity;
        address seller;
        bool active; // active for selling
    }

    event SellEvent(
        uint indexed _energy_id,
        address indexed _seller,
        bytes2 _e_type,
        uint _unit_price,
        uint _quantity
    );
    
    event BuyEvent(
        uint indexed _energy_id,
        address indexed _buyer,
        address indexed _seller,
        bytes2 _e_type,
        uint _unit_price,
        uint _quantity
    );

    
    /**
     * Constrctor function.
     *
     * Initialize addresses of other contracts.
     *
     * @param _cosmosAddress The address of main application contract.
     */
    function CosmosMarket(address _cosmosAddress) public {
        require(_cosmosAddress != 0x0);
        admin = msg.sender;

        // Initialize to other contracts.
        cosmosAddress = _cosmosAddress;
        Cosmos cosmos = Cosmos(cosmosAddress);
        tokenAddress =  cosmos.getAddress(0);
        gridAddress = cosmos.getAddress(1);
    }

    /**
     * Reinitialize values dependant on other functions.
     *
     * @param _cosmosAddress The address of main application contract.
     * @return success Whether the reinitialization was successful.
     */
    function reininializeContracts(address _cosmosAddress) public returns (bool success) {
        require(msg.sender == admin);
        require(_cosmosAddress != 0);

        cosmosAddress = _cosmosAddress;
        Cosmos cosmos = Cosmos(cosmosAddress);
        tokenAddress =  cosmos.getAddress(0);
        gridAddress = cosmos.getAddress(1);

        return true;
    }

    // 1. sell 
    function sell(bytes2 e_type, uint unit_price, uint quantity) public {
        energy_id++;
        
        // memory vs storage? 
        Energy memory energy = Energy(energy_id, e_type, unit_price, quantity, msg.sender, true);
        
        sellList[energy_id] = energy;
        userEnergies[msg.sender].push(energy);

        // SellEventenergy_id, msg.sender, e_type, unit_price, quantity);
    }


    // 2. buy
    function buy(address seller, uint e_id, uint quantity) public payable {
        require(msg.sender != seller);

        require(sellList[e_id].quantity >= quantity);
        require(sellList[e_id].unit_price * quantity == msg.value);

        sellList[e_id].quantity -= quantity;

        
        // seller.transfer(msg.value);

        // BuyEvent(e_id, msg.sender, energies[e_id].seller, energies[e_id].e_type, energies[e_id].unit_price, energies[e_id].quantity);
    }


    // 4. get number of users
    // function getUserCount() public view returns (uint) {
    //     return user_count;
    // }

    // 5. get number of products
    // function getProductCount() public view returns (uint) {
    //     return sellList[1].e_id;
    // }

    // 6. get Entity details
    // function getEntity(address entityAddr) public view returns(string) {
    //     return (entities[entityAddr].name);
    // }

    /**
     * Self destruct.
     */
    function kill() public { 
        if (msg.sender == admin) selfdestruct(admin); 
    }
    
}