//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {DeployBasicNft} from "../../script/DeployBasicNft.s.sol";
import {BasicNft} from "../../src/BasicNft.sol";
import {Test, console} from "forge-std/Test.sol";

contract TestBasicNft is Test {
    DeployBasicNft public s_deployer;
    BasicNft public basicNft;

    string public constant PUG = "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";

    address private immutable user = makeAddr("user");
    uint256 private constant STARTING_USER_BALANCE = 10 ether;

    function setUp() public {
        s_deployer = new DeployBasicNft();
        basicNft = s_deployer.run();

        vm.deal(user, STARTING_USER_BALANCE);
    }

    function testNameAndSymbol() public view {
        string memory expectedName = "Dogie";
        string memory actualName = basicNft.name();

        string memory expectedSymbol = "Dog";
        string memory actualSymbol = basicNft.symbol();

        assert(keccak256(abi.encodePacked(expectedName)) == keccak256(abi.encodePacked(actualName)));
        assert(keccak256(abi.encodePacked(expectedSymbol)) == keccak256(abi.encodePacked(actualSymbol)));
    }

    modifier NftMinted {
        vm.prank(user);
        basicNft.mintNft(PUG);
        _;
    }

    function testCanMintAndHaveSomeBalance() public NftMinted{
        assert(basicNft.balanceOf(user) == 1);
        assert(keccak256(abi.encodePacked(PUG)) == keccak256(abi.encodePacked(basicNft.tokenURI(0))));
    }

    function testTokenCounterCounterUpdating() public NftMinted{
        assert(basicNft.getTokenId() == 1);
    }

    function testMappingUpdated() public NftMinted{
        assert(keccak256(abi.encodePacked(basicNft.getTokenUriFromId(0))) != "0");
    }
}