// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title Healthcare Records System
 * @dev A basic healthcare records management system allowing doctors to add and view patient details on the blockchain.
 */

contract HealthcareRecords {
    
    // Struct for storing patient data
    struct Patient {
        string name;
        uint age;
        string disease;
        string prescription;
        address addedBy;
    }
 // Mapping of patient’s wallet address to their record
    mapping(address => Patient) private patients;

 // Addresses with doctor privileges
    mapping(address => bool) private doctors;

  // Contract owner (admin)
    address public admin;

// Events for logging
    event DoctorAdded(address doctor);
    event RecordAdded(address patient, string disease);
    event RecordUpdated(address patient, string disease);

 constructor() {
        admin = msg.sender;
        doctors[msg.sender] = true; // deployer is a default doctor
    }

 // Modifier for only admin access
    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin allowed");
        _;
    }

// Modifier for only doctors
    modifier onlyDoctor() {
        require(doctors[msg.sender], "Only doctor can perform this action");
        _;
    }


