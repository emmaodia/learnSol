// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.70 <0.9.0;

contract BlindAuction {
    struct Bid {
        bytes32 blindedBid;
        uint deposit;
    }

    address payable public beneficiary;

    uint public biddingEnd;
    uint public revealEnd;
    bool public ended;

    mapping(address => Bid[]) public bids;

    address public highestBidder;
    uint public highestBid;

    mapping(address => uint) pendingReturns;

    event AuctionEnded(address winner, uint highestBid);

    event WithDrawSuccessful(address _to, uint _value);

    error TooEarly(uint time);
    error TooLate(uint time);
    error AuctionEndAlreadyCalled();

    modifier onlyBefore(uint time) {
        if (block.timestamp >= time) {
            revert TooLate(time);
        }
        _;
    }

    modifier onlyAfter(uint time) {
        if (block.timestamp <= time) {
            revert TooEarly(time);
        }
        _;
    }

    constructor(
        uint _biddingTime,
        uint _revealTime,
        address payable _beneficiary
    ) {
        beneficiary = _beneficiary;
        biddingEnd = block.timestamp + _biddingTime;
        revealEnd = biddingEnd + _revealTime;
    }

    function bid(bytes32 _blindedBid) external payable onlyBefore(biddingEnd) {
        bids[msg.sender].push(
            Bid({blindedBid: _blindedBid, deposit: msg.value})
        );
    }

    function reveal(
        uint[] calldata values,
        bool[] calldata fakes,
        bytes32[] calldata secrets
    ) external onlyAfter(biddingEnd) onlyBefore(revealEnd) {
        uint length = bids[msg.sender].length;
        require(values.length == length);
        require(fakes.length == length);
        require(secrets.length == length);

        uint refund;
        for (uint i; i < length; i++) {
            Bid storage bidToCheck = bids[msg.sender][i];
            (uint value, bool fake, bytes32 secret) = (
                values[i],
                fakes[i],
                secrets[i]
            );

            if (
                bidToCheck.blindedBid !=
                keccak256(abi.encodePacked(value, fake, secret))
            ) {
                continue;
            }

            refund += bidToCheck.deposit;
            if (!fake && bidToCheck.deposit >= value) {
                if (placeBid(msg.sender, value)) {
                    refund -= value;
                }
            }

            bidToCheck.blindedBid = bytes32(0);
        }

        payable(msg.sender).transfer(refund);
    }

    function withdraw() external {
        uint amount = pendingReturns[msg.sender];
        if (amount > 0) {
            pendingReturns[msg.sender] = 0;

            payable(msg.sender).transfer(amount);
        }

        emit WithDrawSuccessful(msg.sender, amount);
    }

    function auctionEnd() external onlyAfter(revealEnd) {
        if (ended) {
            revert AuctionEndAlreadyCalled();
        }

        emit AuctionEnded(highestBidder, highestBid);
        ended = true;

        beneficiary.transfer(highestBid);
    }

    function placeBid(address _bidder, uint _value)
        internal
        returns (bool success)
    {
        if (_value <= highestBid) {
            return false;
        }

        if (highestBidder != address(0)) {
            pendingReturns[highestBidder] += highestBid;
        }

        highestBid = _value;
        highestBidder = _bidder;

        return true;
    }
}

/**
 * TODO: The contract implements bids using a bytes32 string stored in an arry Bid[], this ONLY demonstrates how blind bids can placed.
 * The Bids are actually not being placed on any items.
 * An upgraded implementation will require writing a function where the contract owner can create itesm to be bidded on.
 */
