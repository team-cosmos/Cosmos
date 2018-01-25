pragma solidity ^0.4.19;

contract CosmosGod {

	/** Owner of address. */
    address private owner;

	/** Entry point to application. */
    address private cosmosAddress;

    /**
     * Constrctor function.
     *
     * Assign owner.
     */
    function CosmosGod() public {
    	owner = msg.sender;
    }

    /**
     * Transfer ownership of function.
     *
     * @param newOwner The address of the potential owner.
     * @return success True if transfer of ownership was successful.
     */
    function transferOwnership(address newOwner) public return (success bool) {
    	require(newOwner != 0x0);
    	require(msg.sender == owner);
    	owner = newOwner;
    }

    /**
     * Update entry point to Cosmos.
     *
     * @param newAddress The address of the new contract.
     * @return success True if transfer of ownership was successful.
     */
    function updateAddress(address newAddress) public return (success bool){
    	cosmosAddress = 
    }

}