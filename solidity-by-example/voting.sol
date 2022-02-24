// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.9 <0.9.0;

contract Ballot {
    struct Voter {
        uint weight;
        bool voted;
        address delegate;
        uint vote;
    }

    struct Proposal {
        bytes32 name;
        uint voteCount;
    }

    address public chairperson;

    mapping (address => Voter) public voters;

    Proposal[] public proposals;

    constructor (bytes32[] memory proposalNames){
        chairperson = msg.sender;
        voters[chairperson].weight = 1;

        for(uint i; i < proposalNames.length; i++ ){
            proposals.push(Proposal({
                name: proposalNames[i],
                voteCount: 0
            }));
        }
    }

    function giveRightToVote(address voter) external {
        require(msg.sender == chairperson, "Only the Chairperson can give Voting Rights");

        require(!voters[voter].voted, "Voter has already Voted!");

        require(voters[voter].weight == 0);

        voters[voter].weight = 1;

    }

    function delegate(address _to) external {
        Voter storage sender = voters[msg.sender];

        require(!sender.voted, "You already voted");

        require(_to != msg.sender, "Self designation is not allowed");

        while (voters[_to].delegate != address(0)) {
            _to = voters[_to].delegate;

            require(_to != msg.sender);
        }

        Voter storage delegate_ = voters[_to];

        require(delegate_.weight >= 1);
        sender.voted = true;
        sender.delegate = _to;

        if(delegate_.voted) {
            proposals[delegate_.vote].voteCount += sender.weight;
        } else {
            delegate_.weight += sender.weight;
        }
    }

    function vote(uint proposal) external {
        Voter storage sender = voters[msg.sender];

        require(sender.weight != 0, "Has no Voting rights");
        require(!sender.voted, "Already voted");
        sender.voted = true;
        sender.vote = proposal;


        proposals[proposal].voteCount += sender.weight;
    }

    function winningProposal() public view returns (uint winningProposal_) {
        uint winningVoteCount = 0;

        for(uint p = 0; p < proposals.length; p++){
            if (proposals[p].voteCount > winningVoteCount) {
                winningVoteCount = proposals[p].voteCount;
                winningProposal_ = p;
            }
        }
    }

    function winnerName() external view returns (bytes32 winnerName_) {
        winnerName_ = proposals[winningProposal()].name;
    }

}

// Possible Improvements
// Currently, many transactions are needed to assign the rights to vote to all participants. Can you think of a better way?