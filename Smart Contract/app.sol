// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@zetachain/protocol-contracts/contracts/zevm/SystemContract.sol";
import "@zetachain/protocol-contracts/contracts/zevm/interfaces/zContract.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@zetachain/toolkit/contracts/BytesHelperLib.sol";
import "@zetachain/toolkit/contracts/OnlySystem.sol";

contract RealEstateTransaction is zContract, ERC721, OnlySystem, ERC721URIStorage, ERC721Enumerable {
    SystemContract public systemContract;
    error CallerNotOwnerNotApproved();
    uint256 constant BITCOIN = 18332;

    mapping(uint256 => uint256) public tokenAmounts;
    mapping(uint256 => uint256) public tokenChains;
    struct PropertyListing {
        uint propertyId;
        string imageUrl;
        string propertyTitle;
        string propertyLocation;
        uint propertySqft;
        uint propertyBhk;
        uint propertyBath;
        uint propertyPrice;
        address seller;
        address buyer;
        bool isSold;
        string uri;
    }

    event registeredProperty(
        string location,
        uint total_sqft,
        uint bath,
        uint price,
        uint bhk
    );

    uint public propertyListingCount;

    PropertyListing[] public propertyListings;

    mapping(address => uint[]) public userOwnedProperties;
    uint256 public _nextTokenId;

    constructor(address systemContractAddress) ERC721("Entertainment", "ENT") {
        systemContract = SystemContract(systemContractAddress);
        _nextTokenId = 0;
    }

    function onCrossChainCall(
        zContext calldata context,
        address zrc20,
        uint256 amount,
        bytes calldata message
    ) external virtual override onlySystem(systemContract) {
        address recipient;

        if (context.chainID == BITCOIN) {
            recipient = BytesHelperLib.bytesToAddress(message, 0);
        } else {
            recipient = abi.decode(message, (address));
        }

        _mintNFT(recipient, context.chainID, amount, "");
    }

    function _mintNFT(
        address recipient,
        uint256 chainId,
        uint256 amount,
        string memory uri
    ) private {
        uint256 tokenId = _nextTokenId;
        _safeMint(recipient, tokenId);
        tokenChains[tokenId] = chainId;
        tokenAmounts[tokenId] = amount;
        _setTokenURI(tokenId, uri);

        _nextTokenId++;
    }

    function createPropertyListing(string memory imageUrl, string memory propertyTitle, string memory propertyLocation,uint propertySqft, uint propertyBhk, uint propertyBath, uint propertyPrice, string memory uri) public {
        PropertyListing memory newListing;
        newListing.propertyId = propertyListingCount;
        newListing.imageUrl = imageUrl;
        newListing.propertyTitle = propertyTitle;
        newListing.propertyLocation = propertyLocation;
        newListing.propertySqft = propertySqft;
        newListing.propertyBhk = propertyBhk;
        newListing.propertyBath = propertyBath;
        newListing.propertyPrice = propertyPrice;
        newListing.seller = msg.sender;
        propertyListings.push(newListing);
        userOwnedProperties[msg.sender].push(propertyListingCount);
        propertyListingCount++;
        emit registeredProperty(newListing.propertyLocation, newListing.propertySqft, newListing.propertyBath, newListing.propertyPrice, newListing.propertyBhk);
    }

    function buyProperty(uint propertyListingId, uint256 chainID) public payable {
        require(!propertyListings[propertyListingId].isSold, "Property already sold");
        payable(propertyListings[propertyListingId].seller).transfer(msg.value);
        propertyListings[propertyListingId].buyer = msg.sender;
        propertyListings[propertyListingId].isSold = true;
        userOwnedProperties[msg.sender].push(propertyListingId);
    }

    function getAllAvailableProperties() public view returns (PropertyListing[] memory) {
        uint availablePropertiesCount = 0;

        // Count available (not sold) properties
        for (uint i = 0; i < propertyListings.length; i++) {
            if (!propertyListings[i].isSold) {
                availablePropertiesCount++;
            }
        }

        PropertyListing[] memory availableProperties = new PropertyListing[](availablePropertiesCount);
        uint currentIndex = 0;

        // Populate available properties
        for (uint i = 0; i < propertyListings.length; i++) {
            if (!propertyListings[i].isSold) {
                availableProperties[currentIndex] = propertyListings[i];
                currentIndex++;
            }
        }

        return availableProperties;
    }

    function getOwnedProperties(address _ownerAddress) public view returns (PropertyListing[] memory) {
        uint[] memory propertyIds = userOwnedProperties[_ownerAddress];
        PropertyListing[] memory ownedProperties = new PropertyListing[](propertyIds.length);

        // Retrieve owned properties for the given owner address
        for (uint i = 0; i < propertyIds.length; i++) {
            ownedProperties[i] = propertyListings[propertyIds[i]];
        }

        return ownedProperties;
    }
}