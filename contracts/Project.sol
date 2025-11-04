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

    // Add a new doctor (admin only)
    function addDoctor(address _doctor) public onlyAdmin {
        doctors[_doctor] = true;
        emit DoctorAdded(_doctor);
    }

    // Function to register or update a patient's healthcare record
    function addPatientRecord(
        address _patient,
        string memory _name,
        uint _age,
        string memory _disease,
        string memory _prescription
    ) public onlyDoctor {
        require(_patient != address(0), "Invalid patient address");

        // Add or overwrite the patient record
        patients[_patient] = Patient({
            name: _name,
            age: _age,
            disease: _disease,
            prescription: _prescription,
            addedBy: msg.sender
        });

        emit RecordAdded(_patient, _disease);
    }

    // Function to update patient disease and prescription
    function updateRecord(
        address _patient,
        string memory _disease,
        string memory _prescription
    ) public onlyDoctor {
        require(bytes(patients[_patient].name).length != 0, "Patient not found");

        patients[_patient].disease = _disease;
        patients[_patient].prescription = _prescription;

        emit RecordUpdated(_patient, _disease);
    }

    // Function for doctors or patients to view a record
    function viewRecord(address _patient)
        public
        view
        returns (string memory, uint, string memory, string memory, address)
    {
        require(
            msg.sender == _patient || doctors[msg.sender],
            "Access denied"
        );

        Patient memory p = patients[_patient];
        require(bytes(p.name).length != 0, "No record found");

        return (p.name, p.age, p.disease, p.prescription, p.addedBy);
    }
}





