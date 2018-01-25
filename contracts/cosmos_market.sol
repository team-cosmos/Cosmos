pragma solidity ^0.4.0;

contract Cosmos {
    /** Get addresses of other contracts. */
    function getAddress(uint tag) public view returns (address contractAddr) {}
}


contract CosmosGrid {
    /** Get seller's energy balance. */
    function getEnergyBalance(uint16 energyType) public view returns (uint256 listed) {}

    /** Get how much energy seller has reserved for sale. */
    function getEnergyListed(uint16 energyType) public view returns (uint256 listed) {}

    /* Set aside energy for sale */
    function listEnergy(uint16 _energyType, uint256 _value) public returns (bool success) {}

    /** Sale. */
    function transferListedEnergy(address _to, uint16 _energyType, uint256 _value) public {}
}


contract CosmosMarket {

    /** User sell listings. */
    mapping(address => itmap) private sellListings;

    using itamp_impl for itmap;

    /** Number of active sell listings. */
    uint256 private sellListingId;

    /** Admin of this contract. */
    address private admin;

    /** Address of main application contract. */
    address private cosmosAddress;

    /** Address of CosmosToken contract. */
    address private tokenAddress;

    /** Address of CosmosGrid contract. */
    address private gridAddress;
    
    /** Components of a sell lsiting. */
    struct SellListing {
        uint256 id; /* Also serves as index in sellListings. */
        address seller;
        uint16 energyType;
        uint256 quantity;
        uint256 unitPrice;
        bool active;
    }

    event SellEvent(
        uint256 id;
        address indexed seller,
        uint16 energyType,
        uint256 quantity,
        uint256 unitPrice
    );
    
    event BuyEvent(
        uint256 id;
        address indexed buyer,
        address indexed seller,
        uint16 energyType,
        uint256 quantity,
        uint256 unitPrice
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

    /**
     * List a sale.
     *
     * @param energyType The type of energy.
     * @param unitPrice Price per unit.
     * @param quantity The amount to sell.
     * @return success Listing was successful.
     */
    function listSale(uint16 energyType, uint256 unitPrice, uint256 quantity) public returns (bool success) {
        require(quantity > 0);
        require(unitPrice > 0);

        CosmosGrid grid = CosmosGrid(gridAddress);
        uint256 energyBalance = grid.getEnergyBalance(energyType);

        if (energyBalance < quantity) { // Not enough energy to sell.
            return false;
        } else {
            grid.listEnergy(quantity);
        } 

        // memory vs storage? 
        SellListing memory listing = SellListing(sellListingId, msg.sender, energyType, unitPrice, quantity, true);
        
        sellListings[energyType].insert(msg.sender, listing);

        sellListingId += 1;

        return true;
    }

    /**
     * Buy from a listing.
     *
     * @param id Id of the listing.
     * @param quantity The amount to buy.
     * @return success Purchase was successful.
     */
    function buy(uint256 id, uint256 quantity) public payable returns (bool success) {

        /* Fetch listing with id. */
        KeyValue r = sellListings[energyType].iterate_get(id);
        SellListing listing = r.value;

        require(msg.sender != listing.seller);
        require(listing.quantity >= quantity);
        require(listing.unitPrice * quantity) == msg.value);

        /* Move funds */
        @TODO

        /* Update sell listing */
        listing.quantity -= quantity;
        if (quantity <= 0) {
            listing.active = false;
            // sellListings[].remove(listing.seller);
        }

        SellEvent(listing.id, listing.seller, listing.energyType, listing.quantity, listing.unitPrice);
        BuyEvent(listing.id, listing.buyer, listing.seller, listing.energyType, listing.quantity, listing.unitPrice);

        return true;
    }

    /**
     * Fetch information about a sell listing.
     *
     * @param listingId Id of the listing,
     *                  obtained with getMySellListings().
     * @return success Query was successful.
     * @return id Id of the listing.
     * @return seller Address of the seller.
     * @return energyType Type of energy.
     * @return quantity Quantity of sale.
     * @return unitPrice Price per unit.
     */
    function getSellListing(uint256 listingId) 
        returns (bool success, uint256 id, address seller, uint16 energyType, uint256 quantity, uint256 unitPrice) {

        /* Fetch listing with id. */
        KeyValue r = sellListings[energyType].iterate_get(id);

        if (r.key == 0x0) {
            return (false, 0, 0x0, 0, 0, 0);
        }

        SellListing listing = r.value;

        return (true, listing.id, listing.seller, listing.energyType, listing.quantity, listing.unitPrice);

    }

    /**
     * Get my sell listings.
     *
     * @return success Query was successful.
     * @return listings Array of my listings.
     */
    function mySellListings() public payable returns (bool success, SellListing[] listings) {

        /* Fetch listing with address. */
        @TODO

        /* Move funds */
        @TODO

        /* Update sell listing */
        listing.quantity -= quantity;
        if (quantity <= 0) {
            listing.active = false;
            sellListings[energyType].remove(listing.seller);
        }

        SellEvent(listing.id, listing.seller, listing.energyType, listing.quantity, listing.unitPrice);
        BuyEvent(listing.id, listing.buyer, listing.seller, listing.energyType, listing.quantity, listing.unitPrice);

        return true;
    }

    /**
     * Self destruct.
     */
    function kill() public { 
        if (msg.sender == admin) selfdestruct(admin); 
    }
    
}


////////////////////////////////////////////////////////////////////
///////////////////////// Iterable mapping /////////////////////////
////////////////////////////////////////////////////////////////////

struct itmap {
    struct IndexValue { uint keyIndex; SellListing value; }
    struct KeyFlag { address key; bool deleted; }
    struct KeyValue { address key; SellListing value; }

    mapping(address => IndexValue) data;
    KeyFlag[] keys;
    uint size;
}

library itmap_impl {
  function insert(itmap storage self, uint key, uint value) returns (bool replaced) {
    uint keyIndex = self.data[key].keyIndex;
    self.data[key].value = value;
    if (keyIndex > 0) {
      return true;
    }
    else {
      keyIndex = keys.length++;
      self.data[key].keyIndex = keyIndex + 1;
      self.keys[keyIndex].key = key;
      self.size++;
      return false;
    }
  }

  function remove(itmap storage self, uint key) returns (bool success) {
    uint keyIndex = self.data[key].keyIndex;
    if (keyIndex == 0)
      return false;
    delete self.data[key];
    self.keys[keyIndex - 1].deleted = true;
    self.size --;
  }

  function contains(itmap storage self, uint key) {
    return self.data[key].keyIndex > 0;
  }

  function iterate_start(itmap storage self) returns (uint keyIndex) {
    return iterate_next(self, -1);
  }

  function iterate_valid(itmap storage self, uint keyIndex) returns (bool) {
    return keyIndex < self.keys.length;
  }

  function iterate_next(itmap storage self, uint keyIndex) returns (uint r_keyIndex) {
    keyIndex++;
    while (keyIndex < self.keys.length && self.keys[keyIndex].deleted)
      keyIndex++;
    return keyIndex;
  }

  function iterate_get(itmap storage self, uint keyIndex) returns (KeyValue r) {
    r.key = self.keys[keyIndex].key;
    r.value = self.data[key];
  }
}