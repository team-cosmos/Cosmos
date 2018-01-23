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
     * Has to be sent by a smart meter!!!
     *
     * @param owner The address of the owner.
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
        require(ownsMeter(msg.sender, meter));

        ownerOf[meter] = newOwner;

        metersOf[newOwner].push(meter);

        address[] meters = metersOf[msg.sender];

        for (uint i=0; i < meters.length(); i++) {
            delete();
        }

        return true;
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
    function deregisterMeter(address meter) public returns (bool success) {
        require(meter != 0x0);
        require(ownsMeter(msg.sender, meter));

        ownerOf[meter] = user;
        

        return true;
    }

    /**
     * Get owner of a meter's address.
     *
     * @return success Operation was successful.
     * @return user Address of the calling meter's owner.
     */
    function getOwner() public returns (bool success, address user) {
        address owner = ownerOf[msg.sender];

        success = (owner == 0x0);

        return (success, owner);
    }

    /**
     * Get a list of meters that belong to the caller.
     *
     * @return success Operation was successful.
     * @return meters Addresses of the calling user's meters.
     */
    function getMeters() public returns (bool success, address meters) {
        address[] meters = metersOf[msg.sender];

        success = (meters && meters.length > 0);

        return (success, meters);
    }

    /**
     * Check if a meter belongs to a user.
     *
     * @param user The address of the potential owner.
     * @param meter The address of the meter..
     * @return belongs Meter belongs to the user.
     */
    function ownsMeter(address user, address meter) public returns (bool belongs) {
        require(meter != 0x0);
        require(user != 0x0);

        address[] meters = metersOf[user];

        if (meters.length() < 1) {

            return false;

        } else { // Valid list of meters registered under user.

            for (uint i=0; i < meters.length(); i++) {
                if (meters[i] == meter) {
                    return true;
                }
            }
        }

        return false;
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