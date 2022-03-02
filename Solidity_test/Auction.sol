// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.5.0 <0.7.0;

library Balances {
    function move(mapping(address => uint256) storage balances, address from, address to, uint amount) internal {
        require(balances[from] >= amount);
        require(balances[to] + amount >= balances[to]);
        balances[from] -= amount;
        balances[to] += amount;
    }
}

contract Auction {
    address payable public beneficiary; // address that will receive Ether for token
    address public token; // address of the token that is going to be sold
    uint public startPrice; // initial price
    uint public auctionEndPrice; // minimal price above that the auction is continue
    bool ended; // the end of the auction

    mapping(address => uint256) balances;
    using Balances for *;
    mapping(address => mapping (address => uint256)) allowed;

    event LowestPriceDecreased(uint amount); // price changed, because there were no bids for the certain amount of time
    event AuctionEnded(address winner, uint amount); //the bid with price >= lowestPrice is created

    constructor(
        address payable _beneficiary,
        address  _token,
        uint _startPrice,
        uint _auctionEndPrice
    ) public {
        beneficiary = _beneficiary;
        token = _token
        startPrice = _startPrice
        auctionEndPrice = _auctionEndPrice;
    }

    function bid() public payable {
        require(
            !ended,
            "Auction already ended."
        );

        require(
            msg.value > auctionEndPrice,
            "There already is a higher bid."
        );

        if (highestBid != 0) {
            pendingReturns[highestBidder] += highestBid;
        }
        highestBidder = msg.sender;
        highestBid = msg.value;
        emit HighestBidIncreased(msg.sender, msg.value);
    }

    function withdraw() public returns (bool) {
        uint amount = pendingReturns[msg.sender];
        if (amount > 0) {
            pendingReturns[msg.sender] = 0;

            if (!msg.sender.send(amount)) {
                pendingReturns[msg.sender] = amount;
                return false;
            }
        }
        return true;
    }

    function auctionEnd() public {
        require(now >= auctionEndTime, "Auction not yet ended.");
        require(!ended, "auctionEnd has already been called.");

        ended = true;
        emit AuctionEnded(highestBidder, highestBid);

        beneficiary.transfer(highestBid);
    }
}