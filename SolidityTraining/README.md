# Auction

There is my description of the Solidity script above.
This smart-contract provides the auction, when the seller is trying to sell certain token on the balance and receive Ether. Initial price of the token is set by the owner and then slowly decreases until a Bid appears at the current price or the price reaches its set limit.

Required input data (in constructor):
1) beneficiary - the address that will receive Ether for token
2) token - address of the token that is going to be sold
3) startPrice - initial price
4) auctionEndPrice - minimal price above that the auction continues

Required events:
1) LowestPriceDecreased(uint amount) - price changed, because there were no bids for the certain amount of time/blocks (e.g. 1% change per block)
2) AuctionEnded(address winner, uint amount) - the bid with price >= current price is created

Required functions:
1) BalanceOf
2) PriceDecreased
3) Bid
4) TokenTransfer
5) AuctionEnded
