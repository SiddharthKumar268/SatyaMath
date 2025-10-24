// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Voting {
    enum Phase { Created, CommitPhase, RevealPhase, Ended }

    Phase public phase;
    address public owner;

    struct Proposal {
        string name;
        uint256 voteCount;
    }

    Proposal[] public proposals;

    mapping(address => bytes32) public commits;
    mapping(address => bool) public revealed;
    mapping(address => bool) public eligible;

    event Commit(address indexed voter);
    event Reveal(address indexed voter, uint256 indexed proposalId);
    event PhaseAdvanced(Phase newPhase);

    modifier onlyOwner() {
        require(msg.sender == owner, "only owner");
        _;
    }

    modifier inPhase(Phase p) {
        require(phase == p, "wrong phase");
        _;
    }

    constructor(string[] memory _proposalNames) {
        owner = msg.sender;
        for (uint i = 0; i < _proposalNames.length; i++) {
            proposals.push(Proposal({name: _proposalNames[i], voteCount: 0}));
        }
        phase = Phase.Created;
    }

    function addEligible(address voter) external onlyOwner inPhase(Phase.Created) {
        eligible[voter] = true;
    }

    function startCommitPhase() external onlyOwner inPhase(Phase.Created) {
        phase = Phase.CommitPhase;
        emit PhaseAdvanced(phase);
    }

    function startRevealPhase() external onlyOwner inPhase(Phase.CommitPhase) {
        phase = Phase.RevealPhase;
        emit PhaseAdvanced(phase);
    }

    function endVoting() external onlyOwner inPhase(Phase.RevealPhase) {
        phase = Phase.Ended;
        emit PhaseAdvanced(phase);
    }

    function commitVote(bytes32 commit) external inPhase(Phase.CommitPhase) {
        require(eligible[msg.sender], "not eligible");
        require(commits[msg.sender] == bytes32(0), "already committed");
        commits[msg.sender] = commit;
        emit Commit(msg.sender);
    }

    function revealVote(uint256 proposalId, string calldata secret) external inPhase(Phase.RevealPhase) {
        require(eligible[msg.sender], "not eligible");
        require(!revealed[msg.sender], "already revealed");
        bytes32 expected = keccak256(abi.encodePacked(proposalId, secret));
        require(commits[msg.sender] == expected, "commit mismatch");
        revealed[msg.sender] = true;
        proposals[proposalId].voteCount += 1;
        emit Reveal(msg.sender, proposalId);
    }

    function getProposals() external view returns (string[] memory names, uint256[] memory counts) {
        uint len = proposals.length;
        names = new string[](len);
        counts = new uint256[](len);
        for (uint i = 0; i < len; i++) {
            names[i] = proposals[i].name;
            counts[i] = proposals[i].voteCount;
        }
    }

    function proposalCount() external view returns (uint) {
        return proposals.length;
    }

    function getCurrentPhase() external view returns (string memory) {
        if (phase == Phase.Created) return "Created";
        if (phase == Phase.CommitPhase) return "Commit Phase";
        if (phase == Phase.RevealPhase) return "Reveal Phase";
        return "Ended";
    }
}