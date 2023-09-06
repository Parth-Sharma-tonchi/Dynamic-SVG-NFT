//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

//imports
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract MoodNft is ERC721{
    //error
    error MoodNft__CannotFlipIfNotOwner();

    //enums
    enum Mood{
        HAPPY,
        SAD
    }

    //contract variables
    uint256 private s_tokenCounter;
    string private s_happySvgImageUri;
    string private s_sadSvgImageUri;

    //mappings
    mapping(uint256 => Mood) private s_tokenIdToMood;
    mapping(address => uint256) private s_addressTotokenId;

    //constructor
    constructor(string memory happySvgImageUri, string memory sadSvgImageUri) ERC721("Mood NFT", "MN"){
        s_tokenCounter = 0;
        s_happySvgImageUri = happySvgImageUri;
        s_sadSvgImageUri = sadSvgImageUri;
    }

    //functions
    function mintNft() public {
        _safeMint(msg.sender, s_tokenCounter);
        s_addressTotokenId[msg.sender] = s_tokenCounter;
        s_tokenIdToMood[s_tokenCounter] = Mood.HAPPY;
        s_tokenCounter++;
    } 

    function flipMood(uint256 tokenId) public {
        if(!_isApprovedOrOwner(msg.sender, tokenId)){
            revert MoodNft__CannotFlipIfNotOwner();
        }
        if(s_tokenIdToMood[tokenId] == Mood.HAPPY){
            s_tokenIdToMood[tokenId] = Mood.SAD;
        }else{
            s_tokenIdToMood[tokenId] = Mood.HAPPY;
        }
    }

    function _baseURI() internal pure override returns(string memory){
        return "data:application/json;base64,";
    }
    function tokenURI(uint256 tokenId) public view override returns(string memory){

        string memory imageURI;
        if(s_tokenIdToMood[tokenId] == Mood.HAPPY){
            imageURI = s_happySvgImageUri;
        }else{
            imageURI = s_sadSvgImageUri;
        }

        return string(
            abi.encodePacked(
                _baseURI(),Base64.encode(
                    bytes(
                        abi.encodePacked(
                                '{"name":"',
                                name(),
                                '", "description":"An NFT that reflects the mood of the owner, 100% on Chain!", ',
                                '"attributes": [{"trait_type": "moodiness", "value": 100}], "image":"',
                                imageURI,
                                '"}'
                                )
                            )
                        )
                    )
                );
    }

    function getTokenIdFromAddress(address minter) public view returns(uint256){
        return s_addressTotokenId[minter];
    }    

}