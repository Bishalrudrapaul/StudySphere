// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract StudyAbroad {

    // Structures to store data
    struct Student {
        string name;
        bool enrolled;
    }

    struct Institution {
        string name;
        bool accredited;
    }

    struct Agreement {
        address student;
        address institution;
        string details;
        bool approved;
    }

    struct Visa {
        string status;
        bool processed;
    }

    struct Housing {
        string addressDetails;
        bool confirmed;
    }

    // State variables
    mapping(address => Student) public students;
    mapping(address => Institution) public institutions;
    mapping(uint => Agreement) public agreements;
    mapping(address => Visa) public visas;
    mapping(address => Housing) public housings;

    uint public agreementCount = 0;

    // Events to log actions
    event StudentEnrolled(address student, string name);
    event InstitutionRegistered(address institution, string name);
    event AgreementCreated(uint agreementId, address student, address institution, string details);
    event AgreementApproved(uint agreementId);
    event VisaProcessed(address student, string status);
    event HousingConfirmed(address student, string addressDetails);

    // Enroll a student
    function enrollStudent(string memory _name) public {
        students[msg.sender] = Student(_name, true);
        emit StudentEnrolled(msg.sender, _name);
    }

    // Register an institution
    function registerInstitution(string memory _name) public {
        institutions[msg.sender] = Institution(_name, true);
        emit InstitutionRegistered(msg.sender, _name);
    }

    // Create an agreement
    function createAgreement(address _institution, string memory _details) public {
        require(students[msg.sender].enrolled, "Student not enrolled");
        require(institutions[_institution].accredited, "Institution not accredited");

        agreements[agreementCount] = Agreement(msg.sender, _institution, _details, false);
        emit AgreementCreated(agreementCount, msg.sender, _institution, _details);
        agreementCount++;
    }

    // Approve an agreement
    function approveAgreement(uint _agreementId) public {
        require(institutions[msg.sender].accredited, "Only accredited institutions can approve agreements");
        Agreement storage agreement = agreements[_agreementId];
        require(agreement.institution == msg.sender, "Not authorized to approve this agreement");
        agreement.approved = true;
        emit AgreementApproved(_agreementId);
    }

    // Process a visa
    function processVisa(address _student, string memory _status) public {
        require(institutions[msg.sender].accredited, "Only accredited institutions can process visas");
        visas[_student] = Visa(_status, true);
        emit VisaProcessed(_student, _status);
    }

    // Confirm housing
    function confirmHousing(string memory _addressDetails) public {
        require(students[msg.sender].enrolled, "Student not enrolled");
        housings[msg.sender] = Housing(_addressDetails, true);
        emit HousingConfirmed(msg.sender, _addressDetails);
    }

    // Utility functions
    function getStudent(address _student) public view returns (string memory, bool) {
        Student memory student = students[_student];
        return (student.name, student.enrolled);
    }

    function getInstitution(address _institution) public view returns (string memory, bool) {
        Institution memory institution = institutions[_institution];
        return (institution.name, institution.accredited);
    }

    function getAgreement(uint _agreementId) public view returns (address, address, string memory, bool) {
        Agreement memory agreement = agreements[_agreementId];
        return (agreement.student, agreement.institution, agreement.details, agreement.approved);
    }

    function getVisa(address _student) public view returns (string memory, bool) {
        Visa memory visa = visas[_student];
        return (visa.status, visa.processed);
    }

    function getHousing(address _student) public view returns (string memory, bool) {
        Housing memory housing = housings[_student];
        return (housing.addressDetails, housing.confirmed);
    }
}
