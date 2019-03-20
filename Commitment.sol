pragma solidity ^0.4.23;

/*
    Smart contract for public proof of ReliablyME reliability ratings.
    
    This contract stores all of the commitments of each user over all of the 
    possible badges.  

    Copyright 2018 ReliablyMe 
    Developed by Dave McKay - Promulgare Consulting    
*/

contract ReliablyMEcommitments {
    
    // Track the owner of this contract
    address public owner;
    
    // Track the important dates for a commitmentDates
    // offerDate - the date the offer of help is accepted
    // completeDate - the date that the completion of the offer is approved
    struct commitmentDates {
        uint256 offerDate;
        uint256 completeDate;
    }
    
    // This mapping sets up a key pair by user to a mapping of events to dates
    // It can be thought of like:
    //    {userId: {eventId: commitmentDates[]}}
    mapping(uint => mapping(uint => commitmentDates)) public byPerson;
    
    // Set the owner to be the account who deployed the contract
    constructor() public {
        owner = msg.sender;    
    }
    
    // Get the date of the offer acceptance for a user and event 
    // userId - the ReliablyME userId
    // eventId - the ReliablyME event ID
    function getOffer(uint userId, uint eventId) public view returns(uint256 offerDate) {
        return (byPerson[userId][eventId].offerDate);
    }

    // Get the date of the completion acceptance for a user and event
    // userId - the ReliablyME userId
    // eventId - the ReliablyME event ID
    function getComplete(uint userId, uint eventId) public view returns(uint256 completeDate) {
        return (byPerson[userId][eventId].completeDate);
    }

    // Get the date of the offer and completion acceptance for a user and event
    // userId - the ReliablyME userId
    // eventId - the ReliablyME event ID
    function getCommitment(uint userId, uint eventId) public view returns(uint256 offerDate, uint256 completeDate) {
        commitmentDates memory dates = byPerson[userId][eventId];
        return (dates.offerDate, dates.completeDate);
    }
    
    // Set the date of an accepted offer
    // userId - the ReliablyME userId
    // eventId - the ReliablyME event ID
    function setOffer(uint userId, uint eventId) public {
        // Only the owner can set the dates
        if(msg.sender==owner) {
            // Make sure that the event has not already been set as complete
            if(getComplete(userId, eventId)==0) {
                // Set the date to the date and time this block was created
                byPerson[userId][eventId].offerDate=block.timestamp;
            }
        }
    }
    
    // Set the date of an accepted completion
    // userId - the ReliablyME userId
    // eventId - the ReliablyME event ID
    function setComplete(uint userId, uint eventId) public {
        // Only the owner can set the dates
        if(msg.sender==owner) {
            // Make sure that the event has an accepted offer 
            if(getOffer(userId, eventId)>0) {
                // Set the date to the date and time this block was created
                byPerson[userId][eventId].completeDate=block.timestamp;
            }
        }
    }
    
}
