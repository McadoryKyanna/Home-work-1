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

}
