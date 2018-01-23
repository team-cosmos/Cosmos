pragma solidity ^0.4.19;

contract Grid {

    /** Map address of smart meters to their owners. */
    mapping (address => address) private ownerOf;

    /** Map address of users to address of their smart meters. */
    mapping(uint => address[]) private metersOf;

    /** Map address of users to their remaining energy balance. */
    mapping (address => uint256) private energyBalanceOf;

    /**
     * Constrctor function.
     *
     * Constructor that sets up the grid.
     */
    function Grid() {

    }

    /**
     * Assign an owner to a smart meter.
     *
     * @param owner The address of the owner.
     * @return success Operation was successful.
     */
    function registerOwner(address user) public returns (bool success) {
        require(user != 0x0);

        ownerOf[msg.sender] = user;

        return true;
    }

    /**
     * Send energy to grid.
     *
     * @param value Energy in kW.
     * @return success Operation was successful.
     */
    function sendEnergyToGrid(uint value) public returns (bool success){
        require(energyBalanceOf[ownerOf[msg.sender]] + value 
                >= energyBalanceOf[ownerOf[msg.sender]]); // Prevent overflow. 

        energyBalanceOf[ownerOf[msg.sender]] += value;
        return true;
    }

    /**
     * Internal Energy transfer function that can be called only by this contract.
     *
     * @param _from The address of the sender.
     * @param _to The address of the recipient.
     * @param _value The amount to send in kW.
     * @return success Operation was successful.
     */
    function _transferEnergy(address _from, address _to, uint256 _value) internal {
        require(_to != 0x0);
        require(energyBalanceOf[_from] >= _value);
        require(energyBalanceOf[_to] + _value >= energyBalanceOf[_to]); // Prevent overflow

        uint previousBalances = energyBalanceOf[_from] + energyBalanceOf[_to];
        energyBalanceOf[_from] -= _value;
        energyBalanceOf[_to] += _value;

        Transfer(_from, _to, _value);

        assert(energyBalanceOf[_from] + energyBalanceOf[_to] == previousBalances);
    }

    /**
     * Transfer Energy.
     *
     * Send `_value` energy to `_to` from your account
     *
     * @param _to The address of the recipient.
     * @param _value The amount to send in kW.
     */
     function transferEnergy(address _to, uint256 _value) public {
        _transferEnergy(msg.sender, _to, _value);
    }

}