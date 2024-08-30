// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.5.0 <0.7.0;

library Balances {
    function move(mapping(address => mapping (address => uint256)) storage balances, address from, address to, address token, uint amount) internal {
        require(balances[from][token] >= amount);
        require(balances[to][token] + amount >= balances[to][token]);
        balances[from][token] -= amount;
        balances[to][token] += amount;
    }
}

contract Auction {
    address payable public beneficiary; // address that will receive Ether for token
    address public token; // address of the token that is going to be sold
    uint public amount; // amount of the token that is going to be sold
    uint public startPrice; // initial price
    uint public auctionEndPrice; // minimal price above that the auction is continue
    uint public auctionStartTime; // current block at the moment of cotract deploy
    bool ended; // the end of the auction

    using Balances for *;
    mapping(address => mapping (address => uint256)) balances;

    event AuctionEnded(address winner, uint value, uint price, uint amount); //the bid with price >= lowestPrice is created

    constructor(
        address payable _beneficiary,
        address  _token,
        uint _amount,
        uint _startPrice,
        uint _auctionEndPrice
    ) public {
        beneficiary = _beneficiary;
        token = _token;
        startPrice = _startPrice;
        amount = _amount;
        auctionEndPrice = _auctionEndPrice;
        auctionStartTime = block.number;
    }

    function bid(address highestBidder, uint highestBid, uint currentTime, uint currentPrice) public payable {
        require(
            !ended,
            "Auction already ended."
        );

        require(
            msg.value >= auctionEndPrice * amount,
            "The minimal ask is higher."
        );

        currentTime = block.number;
        currentPrice = 99**(currentTime - auctionStartTime)/100**(currentTime - auctionStartTime) * startPrice; //1% price decrease per block

        if (msg.value >= currentPrice * amount) {

            highestBidder = msg.sender;
            highestBid = msg.value;
            ended = true;

            beneficiary.transfer(highestBid);
            balances.move(beneficiary, msg.sender, token, amount);

            emit AuctionEnded(msg.sender, msg.value, currentPrice, amount);
        }
    }
}