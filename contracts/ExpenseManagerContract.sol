// SPDX-License-Identifier: MIT

// class
contract ExpenseManagerContract {
    address public owner;
    // interface
    struct Transaction {
        address user;
        uint amount;
        string reason;
        uint timestamp;
    }

    constructor() {
        owner = msg.sender;
    }
}
