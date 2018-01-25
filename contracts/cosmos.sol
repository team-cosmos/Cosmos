pragma solidity ^0.4.19;

contract Gateway {

    /** Owner of this contract. */
    address private owner;

    /** Address of contracts. 
    * 
    * 1 - CosmosGod.
    * 2 - CosmosGrid.
    *
    */
    mapping (uint16 => address) private ownerOf;


    /**
     * Constrctor function.
     *
     * Set the owner.
     */
    function Gateway() public {
        owner = msg.sender;
    }


}