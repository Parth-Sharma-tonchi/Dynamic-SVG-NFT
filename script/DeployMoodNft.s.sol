//SPDX-License-Identifier:MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MoodNft} from "../src/MoodNft.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract DeployMoodNft is Script{
    MoodNft moodNft;


    function run() external returns(MoodNft){
        string memory happy_svg = vm.readFile("./img/happyMood.svg");
        string memory sad_svg = vm.readFile("./img/sadMood.svg");

        vm.startBroadcast();
        moodNft = new MoodNft(svgToImageUri(happy_svg), svgToImageUri(sad_svg));
        vm.stopBroadcast();

        return moodNft;
    }

    function svgToImageUri(string memory svg) public pure returns(string memory){
        string memory baseUrl = "data:image/svg+xml;base64,";
        string memory svgBase64Encoded = Base64.encode(bytes(string(abi.encodePacked(svg))));
        return string(abi.encodePacked(baseUrl, svgBase64Encoded));
    }
}