pragma solidity ^0.4.19;

contract CosmosGod {

	/** Admin of address. */
    address private admin;

	/** Entry point to application. */
    address private cosmosAddress;

    /**
     * Constrctor function.
     *
     * Assign admin.
     */
    function CosmosGod() public {
    	admin = msg.sender;
    }

    /**
     * Transfer ownership of contract.
     *
     * @param newAdmin The address of the potential new admin.
     * @return success True if transfer of ownership was successful.
     */
    function transferOwnership(address newAdmin) public returns (bool success) {
        require(newAdmin != 0x0);
        require(msg.sender == admin);
        admin = newAdmin;
        return true;
    }

    /**
     * Return entry address to Cosmos.
     *
     * @return cosmosAddr Address of Cosmos.
     */
    function getAddress() public view returns (address cosmosAddr){
        cosmosAddr = cosmosAddress;
        return cosmosAddr;
    }

    /**
     * Update entry address to Cosmos.
     *
     * @param newAddress The address of the new contract.
     * @return success True if transfer of ownership was successful.
     */
    function updateAddress(address newAddress) public returns (bool success) {
        require(newAddress != 0x0);
        require(newAddress != cosmosAddress);
        require(msg.sender == owner);
    	cosmosAddress = newAddress;
        return true;
    }

    /**
     * Self destruct.
     */
    function kill() public { 
        if (msg.sender == owner) selfdestruct(owner); 
    }

}