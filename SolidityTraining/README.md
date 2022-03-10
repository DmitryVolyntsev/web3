# Auction

There is my description of the Solidity script above.
This smart-contract provides the auction, when the seller is trying to sell certain token on the balance and receive Ether. Initial price of the token (in Ether) is set by the owner and then slowly decreases (1% per block) until a Bid appears at the current price or the price reaches its set limit.

Required input data (in constructor):
1) beneficiary - the address that will receive Ether for token
2) token - address of the token that is going to be sold
3) amount - amount of the token that is going to be sold
3) startPrice - initial price in Ether
4) auctionEndPrice - minimal price above that the auction continues

Required event:
1) AuctionEnded(address winner, uint value, uint price, uint amount) - the bid with price >= currentPrice is created

Required functions:
1) Bid - include price changing, value validation and token transfer