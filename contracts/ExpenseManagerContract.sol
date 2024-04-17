// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// class
contract ExpenseManagerContract {
    address public owner;
    // interface (데이터 타입)
    struct Transaction {
        address user;
        uint amount;
        string reason;
        uint timestamp;
    }

    Transaction[] public transactions;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only Owner can execute this");
        _;
    }

    // mapping (주소 : 잔액) : 각 주소의 잔액 저장
    mapping(address => uint) public balances;

    // event : smart contract에서 발생한 이벤트 기록 (블록체인에 영구적으로 기록)
    event Deposit(
        address indexed _from,
        uint amount,
        string _reason,
        uint timestamp
    );

    event Withdraw(
        address indexed _from,
        uint amount,
        string _reason,
        uint timestamp
    );

    // function : smart contract에서 실행 가능한 코드 조각
    // payable : 이더를 전송할 수 있는 함수임을 나타냄,
    function deposit(uint _amount, string memory _reason) public payable {
        require(_amount > 0, "Deposit amount should be greater than 0");
        balances[msg.sender] += _amount;
        transactions.push(
            Transaction(msg.sender, _amount, _reason, block.timestamp)
        );
        emit Deposit(msg.sender, _amount, _reason, block.timestamp);
    }

    function withdraw(uint _amount, string memory _reason) public {
        require(balances[msg.sender] >= _amount, "Insufficient balance");
        balances[msg.sender] -= _amount;
        transactions.push(
            Transaction(msg.sender, _amount, _reason, block.timestamp)
        );
        payable(msg.sender).transfer(_amount);
        emit Withdraw(msg.sender, _amount, _reason, block.timestamp);
    }

    // view : getting some data 만 하는 함수
    function getBalance(address _account) public view returns (uint) {
        return balances[_account];
    }

    function getTransactionsCount() public view returns (uint) {
        return transactions.length;
    }

    function getTransaction(
        uint _index
    ) public view returns (address, uint, string memory, uint) {
        require(_index < transactions.length, "Index out of bounds");
        Transaction memory transaction = transactions[_index];
        return (
            transaction.user,
            transaction.amount,
            transaction.reason,
            transaction.timestamp
        );
    }

    function getAllTransaction()
        public
        view
        returns (
            address[] memory,
            uint[] memory,
            string[] memory,
            uint[] memory
        )
    {
        address[] memory users = new address[](transactions.length);
        uint[] memory amounts = new uint[](transactions.length);
        string[] memory reasons = new string[](transactions.length);
        uint[] memory timestamps = new uint[](transactions.length);

        for (uint i = 0; i < transactions.length; i++) {
            users[i] = transactions[i].user;
            amounts[i] = transactions[i].amount;
            reasons[i] = transactions[i].reason;
            timestamps[i] = transactions[i].timestamp;
        }
        return (users, amounts, reasons, timestamps);
    }

    function changeOwner(address _newOwner) public onlyOwner {
        owner = _newOwner;
    }
}
