//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {BasicNft} from "../src/BasicNft.sol";
import {MoodNft} from "../src/MoodNft.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";

contract MintBasicNft is Script{
    string public constant PUG = "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";
    
    function mintBasicNft(address basicNft) public {
        vm.startBroadcast();
        BasicNft(basicNft).mintNft(PUG);
        vm.stopBroadcast(); 
    }

    function run() external{
        address contractAddress = DevOpsTools.get_most_recent_deployment("BasicNft", block.chainid);
        mintBasicNft(contractAddress);
    }
}

contract MintMoodNft is Script{
    function mintMoodNft(address moodNft) public {
        vm.startBroadcast();
        MoodNft(moodNft).mintNft();
        vm.stopBroadcast();
    }

    function run() external {
        address moodNft = DevOpsTools.get_most_recent_deployment("MoodNft", block.chainid);
        mintMoodNft(moodNft);
    }
}

contract FlipMood is Script{
    

    function flipMood(address moodNft) public {
        uint256 tokenId = MoodNft(moodNft).getTokenIdFromAddress(msg.sender);
        vm.startBroadcast();
        MoodNft(moodNft).flipMood(tokenId);
        vm.stopBroadcast();
    }

    function run() external{
        address moodNft = DevOpsTools.get_most_recent_deployment("MoodNft", block.chainid);
        flipMood(moodNft);    
    }
}

contract SeeNftMetadata is Script{
    function seeNftMetadata(address moodNftAddress) public {
        uint256 tokenId = MoodNft(moodNftAddress).getTokenIdFromAddress(msg.sender);
        vm.startBroadcast();
        string memory tokenURI = MoodNft(moodNftAddress).tokenURI(tokenId);
        vm.stopBroadcast();
        console.log("Paste the URL in the browser to get nft metadata. Because the nft is for practice.");
        console.log(tokenURI);
    }

    function run() external{
        address moodNftAddress = DevOpsTools.get_most_recent_deployment("MoodNft", block.chainid);
        seeNftMetadata(moodNftAddress); 
    }
}