// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.17;
import { console } from "forge-std/console.sol";
import { MudV2Test } from "./MudV2Test.t.sol";
import { BodyOne, BodyTwo, MatchKey } from "../src/constants.sol";
import "../src/codegen/Tables.sol";
import "../src/libraries/Libraries.sol";

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

  function testIndicesInitialized() public {
    setUp();

    vm.startPrank(alice);
    world.moving_castles_SpawnSystem_spawn("Alice");
    vm.stopPrank();

    bytes32 coreEntity = LibUtils.addressToEntityKey(alice);

    assertEq(MatchIndex.get(world, MatchKey), 0);
    assertEq(RoundIndex.get(world, coreEntity), 0);
    assertEq(RoundIndex.get(world, BodyOne), 0);
    assertEq(RoundIndex.get(world, BodyTwo), 0);
  }
}
