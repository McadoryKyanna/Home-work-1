// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DecentralizedVotingSystem {
    address public admin;
    uint256 public proposalCount;

    enum VoteOption { None, Yes, No }

    struct Voter {
        bool hasVoted;
        VoteOption vote;
    }

    struct Proposal {
        uint256 id;
        string description;
        uint256 yesVotes;
        uint256 noVotes;
        bool isOpen;
        mapping(address => bool) voted;
    }

    mapping(address => Voter) public voters;
    mapping(uint256 => Proposal) public proposals;

    event ProposalCreated(uint256 indexed id, string description);
    event VoteCasted(address indexed voter, uint256 indexed proposalId, VoteOption vote);
    event ProposalClosed(uint256 indexed id, uint256 yesVotes, uint256 noVotes, bool passed);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can call this function");
        _;
    }

    modifier hasNotVoted() {
        require(!voters[msg.sender].hasVoted, "You have already voted");
        _;
    }

    constructor() {
        admin = msg.sender;
    }
function createProposal(string memory _description) external onlyAdmin {
        uint256 id = proposalCount++;
        proposals[id] = Proposal(id, _description, 0, 0, true);
        emit ProposalCreated(id, _description);
    }
function vote(uint256 _proposalId, VoteOption _vote) external hasNotVoted {
        require(proposals[_proposalId].isOpen, "Proposal is not open");
        require(_vote == VoteOption.Yes || _vote == VoteOption.No, "Invalid vote option");

        voters[msg.sender] = Voter(true, _vote);

        proposals[_proposalId].voted[msg.sender] = true;

        if (_vote == VoteOption.Yes) {
            proposals[_proposalId].yesVotes++;
        } else {
            proposals[_proposalId].noVotes++;
        }

        emit VoteCasted(msg.sender, _proposalId, _vote);
    }
function closeProposal(uint256 _proposalId) external onlyAdmin {
        require(proposals[_proposalId].isOpen, "Proposal is already closed");

        Proposal storage proposal = proposals[_proposalId];
        proposal.isOpen = false;

        bool passed = proposal.yesVotes > proposal.noVotes;

        emit ProposalClosed(_proposalId, proposal.yesVotes, proposal.noVotes, passed);
    }
}
