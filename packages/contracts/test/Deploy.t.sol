// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.17;
import { console } from "forge-std/console.sol";
import { MudV2Test } from "./MudV2Test.t.sol";
import "../src/codegen/Tables.sol";

contract DeployTest is MudV2Test {
  function testWorldExists() public {
    setUp();
    uint256 codeSize;
    address addr = worldAddress;
    assembly {
      codeSize := extcodesize(addr)
    }
    assertTrue(codeSize > 0);
  }

  function testRevertDoubleInit() public {
    setUp();
    vm.expectRevert(bytes("already initialized"));
    world.moving_castles_MatchSystem_init();
  }
}
