pragma solidity ^0.4.19;

contract Cosmos {
    /** Get addresses of other contracts. */
    function getAddress(uint) public view returns (address) {}
}


contract CosmosToken {
    /** Transfer CosmosToken on behalf of user. */
    function transferFrom(address, address, uint256) public returns (bool) {}
}


contract CosmosGrid {
    /** Get seller's energy balance. */
    function getEnergyBalance(uint16) public view returns (uint256) {}

    /** Get how much energy seller has reserved for sale. */
    function getEnergyListed(uint16) public view returns (uint256) {}

    /* Set aside energy for sale */
    function listEnergy(uint16, uint256) public returns (bool) {}

    /** Sale. */
    function transferListedEnergy(address, uint16, uint256) public {}
}


contract CosmosMarket {

    /** User sell listings. */
    itmap private sellListings;

    /** Number of active sell listings. */
    uint256 private sellListingId;

    /** Map SellListing ids to their addresses. */
    mapping(uint256 => SellListingCache) private sellListingCaches;

    /** Admin of this contract. */
    address private admin;

    /** Address of main application contract. */
    address private cosmosAddress;

    /** Address of CosmosToken contract. */
    address private tokenAddress;

    /** Address of CosmosGrid contract. */
    address private gridAddress;

    /** Keeps track of number of different types of energy. */
    uint16 private energyCount;
    
    /** Components of a sell lsiting. */
    struct SellListing {
        uint256 id; /* Also serves as index in sellListings. */
        address seller;
        uint16 energyType;
        uint256 quantity;
        uint256 unitPrice;
        bool active;
    }

    /** Used to locate sell listing. */
    struct SellListingCache {
        address seller;
        uint16 energyType;
    }

    event SellEvent(
        uint256 id,
        address indexed seller,
        uint16 energyType,
        uint256 quantity,
        uint256 unitPrice
    );
    
    event BuyEvent(
        uint256 id,
        address indexed buyer,
        address indexed seller,
        uint16 energyType,
        uint256 quantity,
        uint256 unitPrice
    );

    
////////////////////////////////////////////////////////////////////
////////////////////////// Cosmos merket ///////////////////////////
////////////////////////////////////////////////////////////////////

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
     * Get my sell listings.
     *
     * @param energyType Type of energy added.
     */
    function _updateEnergyCount(uint16 energyType) internal {
        if (energyType > energyCount) {
            energyCount = energyType;
        }
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
            grid.listEnergy(energyType, quantity);
        } 

        SellListing memory listing = SellListing(sellListingId, msg.sender, energyType, unitPrice, quantity, true);
        sellListings.data[energyType].value[msg.sender] = listing;

        // Bookkeeping.
        SellListingCache memory cache = SellListingCache(msg.sender, energyType);
        sellListingCaches[sellListingId] = cache;
        sellListingId += 1;
        _updateEnergyCount(energyCount);

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
        SellListingCache memory cache = sellListingCaches[id];

        if (cache.seller == 0x0) {
            return false;
        }

        SellListing memory listing = sellListings.data[cache.energyType].value[cache.seller];
        uint cost = listing.unitPrice * quantity;

        require(msg.sender != listing.seller);
        require(listing.quantity >= quantity);
        require(cost == msg.value);

        /* Move funds */
        CosmosToken cosmosToken = CosmosToken(tokenAddress);
        if (!cosmosToken.transferFrom(msg.sender, listing.seller, cost)) {
            return false;
        }

        /* Update sell listing */
        listing.quantity -= quantity;
        if (quantity <= 0) {
            listing.active = false;
            // sellListings[].remove(listing.seller);
        }

        SellEvent(listing.id, listing.seller, listing.energyType, listing.quantity, listing.unitPrice);
        BuyEvent(listing.id, msg.sender, listing.seller, listing.energyType, listing.quantity, listing.unitPrice);

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
    function getSellListing(uint256 listingId) public view
        returns (bool success, uint256 id, address seller, uint16 energyType, 
                 uint256 quantity, uint256 unitPrice, bool active) {

        /* Fetch listing with id. */
        SellListingCache memory cache = sellListingCaches[listingId];

        if (cache.seller == 0x0) {
            return (false, 0, 0x0, 0, 0, 0, false);
        }

        SellListing memory listing = sellListings.data[cache.energyType].value[cache.seller];

        return (true, listing.id, listing.seller, listing.energyType, 
                listing.quantity, listing.unitPrice, listing.active);

    }

    /**
     * Get my sell listings.
     *
     * @return success Query was successful.
     * @return listings Array of my listings.
     */
    function mySellListings() public view returns (bool success, uint256[] listingIds) {

        success = false;

        listingIds = new uint256[](energyCount);

        for (uint16 i = 0; i < energyCount; i++) {
            SellListing memory listing = sellListings.data[i].value[msg.sender];

            if (listing.seller == msg.sender) {
                listingIds[i] = listing.id;
                success = true;
            }
        }

        return (success, listingIds);
    }

    /**
     * Get multiple sell listings, grouped by energy type.
     * Fetches ids of listing indices 'from' to 'to', inclusive.
     *
     * @param energyType Type of energy to query.
     * @param from Inclusive first index of sale listing.
     * @param to Inclusive final index of sale listing.
     * @param active If true, only active listings will be included.
     * @return success Query was successful.
     * @return listings Array of listing ids.
     */
    function getSellListingsByType(uint16 energyType, uint256 from, uint256 to, bool active) 
                public view returns (bool success, uint256[] listingIds) {

        require(from <= to);
        require(to + 1 > to); // Prevent overflow.
        require(to - from <= to); // Prevent overflow.

        success = false;

        uint256 goal = to + 1 - from;
        uint256 counter = 0;
        uint256 found = 0;

        listingIds = new uint256[](goal);

        while (found < goal && counter < 100) {
            var (suc, , sel, eng, , , act) = getSellListing(counter);

            bool sellerValid = (sel != 0x0);
            bool energyValid = (energyType == eng);

            if (suc && sellerValid && energyValid) {
                if (!active || act) {
                    listingIds[found] = counter; 
                    found += 1;
                } 
            } 

            counter += 1;
        }

        success = true;
        return (success, listingIds);
    }

    /**
     * Self destruct.
     */
    function kill() public { 
        if (msg.sender == admin) selfdestruct(admin); 
    }

////////////////////////////////////////////////////////////////////
///////////////////////// Iterable mapping /////////////////////////
////////////////////////////////////////////////////////////////////

    struct itmap {
        mapping(uint16 => IndexValue) data;
        KeyFlag[] keys;
    }

    struct IndexValue { uint16 keyIndex; mapping(address => SellListing) value; }
    struct KeyFlag { uint16 key; bool deleted; }
    struct KeyValue { uint16 key; mapping(address => SellListing) value; }
    
}