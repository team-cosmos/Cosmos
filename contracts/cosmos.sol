pragma solidity ^0.4.19;

contract Cosmos {

    /** Admin of this contract. */
    address private admin;

    /** Address of contracts. 
    * 
    * 0 - CosmosToken.
    * 1 - CosmosGrid.
    * 2 - CosmosMarket.
    *
    */
    mapping (uint => address) private addresses;

    /**
     * Constrctor function.
     *
     * Set the admin.
     */
    function Cosmos() public {
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
     * Return address of contracts.
     *
     * @param tag The identifying tag of the contract.
     * @return contractAddr Address of contract with tag.
     */
    function getAddress(uint tag) public view returns (address contractAddr) {
        contractAddr = addresses[tag];
        return contractAddr;
    }

    /**
     * Update address of contracts.
     *
     * @param tag The identifying tag of the new contract.
     * @param newAddress The address of the new contract.
     * @return success True if update of address was successful.
     */
    function updateAddress(uint tag, address newAddress) public returns (bool success) {
        require(msg.sender == admin);

        addresses[tag] = newAddress;
        
        return true;
    }

    /**
     * Self destruct.
     */
    function kill() public { 
        if (msg.sender == admin) selfdestruct(admin); 
    }

}