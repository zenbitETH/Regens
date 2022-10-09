//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "./DAO.sol";
import "hardhat/console.sol";
contract PunkCity is ERC1155 {


    string public name = "Punk Cities";
    uint256 public placeId;
    uint256 private energy;
    uint256 private chip;
    // the use of constant is not coherent if there can be more than one upgrade possible
    uint256 constant public energyPerPlaceTreshold = 2;
    uint256 constant public chipPerPlaceTreshold = 2;
    uint256 constant public verificationPerPlaceTreshold = 2;
    address[] public registeredUsers;

    enum Type {
         Basketball_court,
         Bus_Stop,
         City_Hall,
         Cityzen_Theater,
         Community_center,
         Fireman_Station,
         Hospital,
         Kids_playground,
         Landmark,
         Open_air_gym,
         Police_Station,
         Public_Park,
         Soccer_court,
         Stadium,
         Temple,
         Art_Gallery,
         Beach,
         Bike_Road,
         Camping_site,
         Museum,
         Recycling_can,
         Skate_Park,
         Library,
         University,
         Coworking_space,
         Industrial_Park,
         Tech_company,
         Technology_Cluster
    }

    enum Quest {
        Solarpunk,
        Cyberpunk
    } 

    struct Place {
        Type placeType;
        address registerAddress;
        uint256 verificationTimes;
        uint256 energyPerPlace;
        uint256 chipPerPlace;
        uint256 placeIdLevel;
        
    }
    Place place;    


    mapping(uint => Place) public placeIdToPlaceDetail;
    mapping(address => uint256) public energyPerAddress;
    mapping(address => uint256) public chipPerAddress;
    mapping(address => mapping(uint256 => bool)) public verifiersPerPlaceId; 
    mapping(address => mapping(uint256 => Quest)) public playerQuestTypePerPlaceId; 
    mapping(address => mapping(uint256 => uint256)) public playerEnergyDepositedPerPlaceId; 
    mapping(address => mapping(uint256 => uint256)) public playerChipDepositedPerPlaceId;   
    mapping (uint256 => string) uris;   

    address dao;
    modifier isUserRegistered(address _address,DAO.Role expectedRole) {
        
       require(DAO(dao).checkAccess(expectedRole, _address));
        _;
    }
    modifier fromDao(){
        require(msg.sender == dao);
        _;
    }

    // this modifier doesn't look like a solid solution. doesn't work with place id 0 
    modifier placeIdExists(uint256 _placeId) {
        require(_placeId <= placeId, "This place id doesn't exist");
        _;
    }

    event PlaceCreated(address indexed _from, uint256 _placeId, uint256 _questType, uint256 _placeType);
    event PlaceVerified(address indexed _from, uint256 _placeId, uint256 _questType);
    event EnergyTransfer(address indexed _from, uint256 _placeId);
    event ChipTransfer(address indexed _from, uint256 _placeId);
    
    constructor() ERC1155("") {
        placeId = 0;
        
    }    
    function setDao(address _dao)external{
        dao = _dao;
        console.log("addpunk",address(this));
    }


    /**
     * @dev User is registering a place in the game
     */

    function registerPlace(uint256 _placeType, uint256 _questType, string memory _ipfsuri) public  {

        // updating the place struct
        placeIdToPlaceDetail[placeId].placeType = Type(_placeType);
        placeIdToPlaceDetail[placeId].registerAddress = msg.sender;

        // updating players' mappings
        //placeIdToRegisterAddress[placeId] = msg.sender;
        verifiersPerPlaceId[msg.sender][placeId] = true;        
        playerQuestTypePerPlaceId[msg.sender][placeId] = Quest(_questType);

        // user gets one energy point for registering place
        if (_questType == 0) {
            energyPerAddress[msg.sender] += 1;
        } else {
            chipPerAddress[msg.sender] += 1;
        }

        //registration results in the place being minted as an nft. the nft id will be the same as the placeId
        mint(msg.sender, placeId, 1, "");
        setTokenUri(placeId, _ipfsuri);

        emit PlaceCreated(msg.sender, placeId, _questType, _placeType);
        emit EnergyTransfer(msg.sender, placeId);        

        placeId += 1;
    }


    /**
     * @dev User is verifying a place in the game. Place register is not allowed to verify its own place
     */

    function verifyPlace(uint256 _placeId, uint256 _questType) public isUserRegistered(msg.sender,DAO.Role.member) {

        require(_placeId < placeId, "This placeId doesn't exist yet");
        require(verifiersPerPlaceId[msg.sender][_placeId] == false, "You can't verify twice");

        placeIdToPlaceDetail[_placeId].verificationTimes += 1;

        //placeIdToVerificationTimes[_placeId] += 1;

        if (_questType == 0) {
            energyPerAddress[msg.sender] += 1;
        } else {
            chipPerAddress[msg.sender] += 1;
        }     

        // mappings updated. with this we know the address that verify a certain place id
        verifiersPerPlaceId[msg.sender][_placeId] = true;  
        playerQuestTypePerPlaceId[msg.sender][_placeId] = Quest(_questType); 

        emit PlaceVerified(msg.sender, _placeId, _questType );
        emit EnergyTransfer(msg.sender, _placeId);
    }

    //WARNING! just for the sake of testing.
    function transferEnergyAndchips(address _to, uint256 _energy, uint256 _chips) public {

        energyPerAddress[_to] += _energy;
        chipPerAddress[_to] += _chips;
    }

    function depositEnergy(uint256 _placeId, uint256 _energy) public placeIdExists(_placeId) {

        require(energyPerAddress[msg.sender] >= _energy, "You don't have enough energy");

        // track how much was deposited
        playerEnergyDepositedPerPlaceId[msg.sender][_placeId] += _energy;

        placeIdToPlaceDetail[_placeId].energyPerPlace += _energy;      
        //energyPerPlace[_placeId] += _energy;
        energyPerAddress[msg.sender] -= _energy;

        emit EnergyTransfer(msg.sender, _placeId);                
    }

    function depositChip(uint256 _placeId, uint256 _chips) public placeIdExists(_placeId) {

        require(chipPerAddress[msg.sender] >= _chips, "You don't have enough chips");

        // track how much was deposited
        playerChipDepositedPerPlaceId[msg.sender][_placeId] += _chips;
        
        placeIdToPlaceDetail[_placeId].chipPerPlace += _chips;
        chipPerAddress[msg.sender] -= _chips;

        emit ChipTransfer(msg.sender, _placeId);                
    }

     /**
     * @dev User can upgrade a place after some conditions are met. As a result, rewards are shared among verifiers
     */

    function assignReward(address _player, uint256 _placeId) public view returns(uint256, uint256) {

        uint256 energyReward = 0;
        uint256 chipReward = 0;

        energyReward = playerEnergyDepositedPerPlaceId[_player][_placeId] * 2; 
        chipReward = playerChipDepositedPerPlaceId[_player][_placeId] * 2;
        return(energyReward, chipReward);
    }

    function upgradePlace(uint256 _placeId) public placeIdExists(_placeId)isUserRegistered(msg.sender,DAO.Role.OG) {

        require(placeIdToPlaceDetail[_placeId].verificationTimes >= verificationPerPlaceTreshold, "This place can't be upgraded because there are not enough verifications");
        require(placeIdToPlaceDetail[_placeId].energyPerPlace >= energyPerPlaceTreshold, "This place can't be upgraded because there is not enough energy deposited");
        require(placeIdToPlaceDetail[_placeId].chipPerPlace >= chipPerPlaceTreshold, "This place can't be upgraded because there are not enough chips deposited");
        //to check functionality: require(verifiersPerPlaceId[msg.sender][_placeId] == true, "Only verifiers of this place can upgrade it");        

        // new nfts of the same token id are minted and shared amond verifiers.
        mint(msg.sender, _placeId, placeIdToPlaceDetail[_placeId].verificationTimes, "");
        // calculate rewards
        address[] memory verifiers = getVerifiers(_placeId);
        for(uint i = 0; i < verifiers.length; i++) {
            // an nft should not be sent to the regster
            if(verifiers[i] == placeIdToPlaceDetail[_placeId].registerAddress) {
                if(verifiers[i] == msg.sender) {
                    // person that upgrades receives 5x the units deposited
                    uint256 energyReward = playerEnergyDepositedPerPlaceId[verifiers[i]][_placeId] * 5;
                    uint256 chipReward = playerChipDepositedPerPlaceId[verifiers[i]][_placeId] * 5;
                    energyPerAddress[verifiers[i]] += (energyReward + 1);
                    chipPerAddress[verifiers[i]] += (chipReward + 1);                            
                } else {
                    // verifiers received double the amount of units deposited after upgrade
                    (uint256 energyReward1, uint256 chipReward1) = assignReward(verifiers[i], _placeId);
                    energyPerAddress[verifiers[i]] += (energyReward1 + 1);
                    chipPerAddress[verifiers[i]] += (chipReward1 + 1);                   
                }        
            } else {
                safeTransferFrom(msg.sender, verifiers[i], _placeId, 1, "");
                if(verifiers[i] == msg.sender) {
                    // person that upgrades receives 5x the units deposited
                    uint256 energyReward = playerEnergyDepositedPerPlaceId[verifiers[i]][_placeId] * 5;
                    uint256 chipReward = playerChipDepositedPerPlaceId[verifiers[i]][_placeId] * 5;
                    energyPerAddress[verifiers[i]] += (energyReward + 1);
                    chipPerAddress[verifiers[i]] += (chipReward + 1);                            
                } else {
                    // verifiers received double the amount of units deposited after upgrade
                    (uint256 energyReward1, uint256 chipReward1) = assignReward(verifiers[i], _placeId);
                    energyPerAddress[verifiers[i]] += (energyReward1 + 1);
                    chipPerAddress[verifiers[i]] += (chipReward1 + 1);                   
                }                  
            }     
        }
        //upgrade next level
        placeIdToPlaceDetail[_placeId].placeIdLevel += 1;        

    }

    function getVerifiers(uint256 _placeId) public view returns(address[] memory) {

        //adding 1 because register is also added among the verifiers
        address[] memory result = new address[](placeIdToPlaceDetail[_placeId].verificationTimes + 1);
        uint counter = 0;

        for (uint256 i = 0; i < registeredUsers.length; i++) {
            if(verifiersPerPlaceId[registeredUsers[i]][_placeId] == true) {
                result[counter] = (registeredUsers[i]);
                counter++;
            }
        }
        return result;
    }  

    function getPlaceIdPerAddress() public view returns(uint256[] memory) {

        uint256[] memory result = new uint256[](placeId);
        uint counter = 0;

        for (uint256 i = 0; i < placeId; i++) {
            if(placeIdToPlaceDetail[i].registerAddress == msg.sender) {
                result[counter] = (i);
                counter++;
            }
        }
        return result;
    } 

// Minting and metadata

    function mint(address account, uint256 id, uint256 amount, bytes memory data)
        private
    {
        _mint(account, id, amount, data);
    }

    function uri(uint256 _tokenId) override public view returns (string memory) {
        return(uris[_tokenId]);
    } 

    function setTokenUri(uint256 _tokenId, string memory _uri) internal {
        require(bytes(uris[_tokenId]).length == 0, "Cannot set uri twice"); 
        uris[_tokenId] = _uri; 
    }         
}