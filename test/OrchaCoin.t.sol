// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;


import "forge-std/Test.sol";

import "src/OrchaCoin.sol";

contract OrchaCoinTest is Test {
    OrchaCoin c;

    function setUp() public {
        c = new OrchaCoin(address(this));
    }

    function testInitialSupply() public view{
        assert(c.totalSupply() == 0);
    }

    function testMint() public{
        c.mint(0xc42e5339259E9607Aaf60d3A632767dd753EdDE8, 10);
        assert(c.totalSupply() == 10);
        assert(c.balanceOf(0xc42e5339259E9607Aaf60d3A632767dd753EdDE8) == 10);
    }

    function Rever() public{
        c.mint(0xc42e5339259E9607Aaf60d3A632767dd753EdDE8, 10);
        assert(c.totalSupply() == 10);
        assert(c.balanceOf(0xc42e5339259E9607Aaf60d3A632767dd753EdDE8) == 10);
    }
}
