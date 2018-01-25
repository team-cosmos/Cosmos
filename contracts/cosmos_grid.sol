pragma solidity ^0.4.19;

contract CosmosGrid {

    /** Admin of this contract. */
    address private admin;

    /** Map address of smart meters to their owners. */
    mapping (address => address) private ownerOf;

    /** Map address of users to address of their smart meters. */
    mapping(address => address[]) private metersOf;

    /** Map address of users to their remaining energy balance. */
    mapping (uint16 => mapping (address => uint256)) private energyBalanceOf;

    /** Map address of users to their energy on sale. */
    mapping (uint16 => mapping (address => uint256)) private energyListedOf;

    /**
     * Constrctor function.
     *
     * Constructor that initializes the grid and sets the admin.
     */
    function CosmosGrid() public {
        admin = msg.sender;
    }


    ////////////////////////////////////////////////////////////////////
    //////////////////////// Internal functions ////////////////////////
    ////////////////////////////////////////////////////////////////////

    /**
     * Check if a meter belongs to a user.
     *
     * @param user The address of the potential owner.
     * @param meter The address of the meter.
     * @return belongs Meter belongs to the user.
     */
    function _hasMeter(address user, address meter) internal view returns (bool belongs) {
        require(meter != 0x0);
        require(user != 0x0);
        require(user != meter);

        address[] memory meters = metersOf[user];

        if (meters.length < 1) {

            return false;

        } else { // Valid list of meters registered under user.

            for (uint i=0; i < meters.length; i++) {
                if (meters[i] == meter) {
                    return true;
                }
            }
        }

        return false;
    }

    /**
     * Assign an owner to a smart meter.
     *
     * Has to be sent by a smart meter!!!
     *
     * @param user The address of the owner.
     * @param meter The address of the meter.
     * @return success Operation was successful.
     */
    function _deregisterMeter(address user, address meter) internal view returns (bool success) {
        require(user != 0x0);
        require(meter != 0x0);
        require(user != meter);
        require(_hasMeter(msg.sender, meter));

        address[] memory meters = metersOf[msg.sender];

        // Find meter in current owner's array.
        int meterIndex = -1;
        for (uint i=0; i < meters.length; i++) {
            if (meters[i] == meter) {
                meterIndex = int(i);
            }
        }

        // Remove from array.
        if (meterIndex != -1) {
            delete(meters[i]);
            return true;
        } else {
            return false;
        }  
    }

    /**
     * Internal energy transfer function that can be called only by this contract.
     *
     * @param _from The address of the sender.
     * @param _to The address of the recipient.
     * @param _tag The type of energy to transfer.
     * @param _value The amount to send in kW.
     * @return success Operation was successful.
     */
    function _transferEnergyBalance(address _from, address _to, uint16 _tag, uint256 _value) internal {
        require(_from != 0x0);
        require(_to != 0x0);
        require(_from != _to);
        require(energyBalanceOf[_tag][_from] >= _value);
        require(energyBalanceOf[_tag][_to] + _value >= energyBalanceOf[_tag][_to]); // Prevent overflow

        uint previousBalances = energyBalanceOf[_tag][_from] + energyBalanceOf[_tag][_to];
        energyBalanceOf[_tag][_from] -= _value;
        energyBalanceOf[_tag][_to] += _value;

        assert(energyBalanceOf[_tag][_from] + energyBalanceOf[_tag][_to] == previousBalances);
    }

    /**
     * Internal energy sale function that can be called only by this contract.
     *
     * @param _from The address of the sender.
     * @param _to The address of the recipient.
     * @param _tag The type of energy to transfer.
     * @param _value The amount to send in kW.
     * @return success Operation was successful.
     */
    function _transferListedEnergy(address _from, address _to, uint16 _tag, uint256 _value) internal {
        require(_from != 0x0);
        require(_to != 0x0);
        require(_from != _to);
        require(energyListedOf[_tag][_from] >= _value);
        require(energyListedOf[_tag][_to] + _value >= energyBalanceOf[_tag][_to]); // Prevent overflow

        uint previousBalances = energyListedOf[_tag][_from] + energyBalanceOf[_tag][_to];
        energyListedOf[_tag][_from] -= _value;
        energyBalanceOf[_tag][_to] += _value;

        assert(energyListedOf[_tag][_from] + energyBalanceOf[_tag][_to] == previousBalances);
    }


    ////////////////////////////////////////////////////////////////////
    ///////////////////////// Public functions /////////////////////////
    ////////////////////////////////////////////////////////////////////

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
     * Assign an owner to a smart meter.
     *
     * Has to be sent by a smart meter!!!
     *
     * @param user The address of the owner.
     * @return success Operation was successful.
     */
    function registerOwner(address user) public returns (bool success) {
        require(user != 0x0);

        ownerOf[msg.sender] = user;

        metersOf[user].push(msg.sender);

        return true;
    }

    /**
     * Transfer ownership of a smart meter.
     * 
     * @param newOwner The address of the new owners.
     * @param meter The address of the meter.
     * @return success Operation was successful.
     */
    function transferMeter(address newOwner, address meter) public returns (bool success) {
        require(newOwner != 0x0);
        require(meter != 0x0);
        require(newOwner != meter);
        require(_hasMeter(msg.sender, meter));

        if (_deregisterMeter(msg.sender, meter)) {

            ownerOf[meter] = newOwner;
            metersOf[newOwner].push(meter);
            return true;

        } else {

            return false;
        }
    }

    /**
     * Delete a smart meter.
     * 
     * A discussion of semantics:
     * https://english.stackexchange.com/questions/25931/unregister-vs-deregister
     *
     * @param meter The address of the meter.
     * @return success Operation was successful.
     */
    function deregisterMeter(address meter) public view returns (bool success) {
        return _deregisterMeter(msg.sender, meter);
    }

    /**
     * Get owner of a meter's address.
     *
     * @return success Operation was successful.
     * @return user Address of the calling meter's owner.
     */
    function getOwner() public view returns (bool success, address user) {
        user = ownerOf[msg.sender];

        success = (user != 0x0);

        return (success, user);
    }

    /**
     * Get a list of meters that belong to the caller.
     *
     * @return success Operation was successful.
     * @return meters Addresses of the calling user's meters.
     */
    function getMeters() public view returns (bool success, address[] meters) {
        meters = metersOf[msg.sender];

        success = (meters.length > 0);

        return (success, meters);
    }

    /**
     * Send energy to grid.
     *
     * @param tag The type of energy to send.
     * @param value Energy in kW.
     * @return success Operation was successful.
     */
    function sendEnergyToGrid(uint16 tag, uint256 value) public returns (bool success){
        require(energyBalanceOf[tag][ownerOf[msg.sender]] + value 
                >= energyBalanceOf[tag][ownerOf[msg.sender]]); // Prevent overflow. 

        energyBalanceOf[tag][ownerOf[msg.sender]] += value;
        return true;
    }

    /**
     * Get energy balance.
     *
     * @param tag The type of energy.
     * @return balance Amount of energy in kw.
     */
    function getEnergyBalance(uint16 tag) public view returns (uint256 balance) {
        return energyBalanceOf[tag][msg.sender];
    }

    /**
     * Get energy set aside for sale.
     *
    * @param tag The type of energy.
     * @return listed Amount of energy in kw.
     */
    function getEnergyListed(uint16 tag) public view returns (uint256 listed) {
        return energyListedOf[tag][msg.sender];
    }

    /**
     * Get total energy of specified type.
     *
     * @param tag The type of energy.
     * @return listed Amount of energy in kw.
     */
    function getTotalEnergyType(uint16 tag) public view returns (uint256 listed) {
        require(energyBalanceOf[tag][msg.sender] + energyListedOf[tag][msg.sender] >= energyBalanceOf[tag][msg.sender]);
        require(energyBalanceOf[tag][msg.sender] + energyListedOf[tag][msg.sender] >= energyListedOf[tag][msg.sender]);
        return energyBalanceOf[tag][msg.sender] + energyListedOf[tag][msg.sender];
    }

    /**
     * Transfer energy balance.
     *
     * Send `_value` energy to `_to` from your balance.
     *
     * @param _to The address of the recipient.
     * @param _tag The type of energy to transfer.
     * @param _value The amount to send in kW.
     */
    function transferEnergyBalance(address _to, uint16 _tag, uint256 _value) public {
        _transferEnergyBalance(msg.sender, _to, _tag, _value);
    }

    /**
     * Transfer listed energy.
     *
     * Send `_value` energy to `_to` from your energy list (sell).
     * Note that the energy moves from msg.sender's energy listing 
     * to _to's energy balance.
     *
     * @param _to The address of the recipient.
     * @param _tag The type of energy to transfer.
     * @param _value The amount to send in kW.
     */
    function transferListedEnergy(address _to, uint16 _tag, uint256 _value) public {
        _transferListedEnergy(msg.sender, _to, _tag, _value);
    }

    /**
     * Set aside a portion of energy for sale.
     *
     * @param _tag The type of energy to list.
     * @param _value The amount to list in kW.
     * @return success Operation was successful.
     */
    function listEnergy(uint16 _tag, uint256 _value) public returns (bool success) {
        require(energyBalanceOf[_tag][msg.sender] >= _value);
        // Prevent overflow.
        require((energyBalanceOf[_tag][msg.sender] -= _value) <= energyBalanceOf[_tag][msg.sender]);
        require((energyListedOf[_tag][msg.sender] += _value) >= energyListedOf[_tag][msg.sender]);

        energyBalanceOf[_tag][msg.sender] -= _value;
        energyListedOf[_tag][msg.sender] += _value;

        success = true;
        return success;
    }

    /**
     * Add energy back to balance for sale listing.
     *
     * @param _tag The type of energy to add.
     * @param _value The amount to add in kW.
     * @return success Operation was successful.
     */
    function unlistEnergy(uint16 _tag, uint256 _value) public returns (bool success) {
        require(energyListedOf[_tag][msg.sender] >= _value);
        // Prevent overflow.
        require((energyBalanceOf[_tag][msg.sender] += _value) >= energyBalanceOf[_tag][msg.sender]);
        require((energyListedOf[_tag][msg.sender] -= _value) <= energyListedOf[_tag][msg.sender]);

        energyBalanceOf[_tag][msg.sender] += _value;
        energyListedOf[_tag][msg.sender] -= _value;
        
        success = true;
        return success;
    }

    /**
     * Self destruct.
     */
    function kill() public { 
        if (msg.sender == admin) selfdestruct(admin); 
    }


}