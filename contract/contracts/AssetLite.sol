// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract AssetLite {
    address public owner;
    uint256 public nextPropertyId = 1;

    struct Property {
        address owner;
        uint256 totalSupply;
        uint256 remainingSupply;
        uint256 pricePerToken;
        string uri;
    }

    mapping(uint256 => Property) public properties;
    mapping(address => mapping(uint256 => uint256)) public ownershipShares;

    event PropertyCreated(uint256 indexed propertyId, address indexed owner, uint256 totalSupply, uint256 pricePerToken, string uri);
    event OwnershipTransferred(uint256 indexed propertyId, address indexed from, address indexed to, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the contract owner can call this function");
        _;
    }

    modifier propertyExists(uint256 propertyId) {
        require(propertyId > 0 && propertyId < nextPropertyId, "Property does not exist");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function createProperty(uint256 totalSupply, uint256 pricePerToken, string memory uri) external onlyOwner {
        require(totalSupply > 0, "Total supply must be greater than zero");
        require(pricePerToken > 0, "Price per token must be greater than zero");

        properties[nextPropertyId] = Property({
            owner: owner,
            totalSupply: totalSupply,
            remainingSupply: totalSupply,
            pricePerToken: pricePerToken,
            uri: uri
        });

        nextPropertyId++;

        emit PropertyCreated(nextPropertyId - 1, owner, totalSupply, pricePerToken, uri);
    }

    function transferOwnership(uint256 propertyId, address to, uint256 amount) external propertyExists(propertyId) {
        Property storage property = properties[propertyId];
        require(property.owner == msg.sender, "Only the property owner can transfer ownership");
        require(amount > 0 && amount <= property.remainingSupply, "Invalid amount to transfer");

        property.remainingSupply -= amount;
        ownershipShares[to][propertyId] += amount;

        emit OwnershipTransferred(propertyId, msg.sender, to, amount);
    }

    function getOwnershipShares(uint256 propertyId, address ownerAddress) external view propertyExists(propertyId) returns (uint256) {
        return ownershipShares[ownerAddress][propertyId];
    }

    function getPropertyURI(uint256 propertyId) public view propertyExists(propertyId) returns (string memory) {
        return properties[propertyId].uri;
    }
}
