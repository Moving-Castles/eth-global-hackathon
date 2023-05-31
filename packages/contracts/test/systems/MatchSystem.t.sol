// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.17;
import { console } from "forge-std/console.sol";
import { MudV2Test } from "../MudV2Test.t.sol";
import { BodyOne, BodyTwo, MatchKey, MAX_MATCH_DURATION } from "../../src/constants.sol";
import "../../src/codegen/Tables.sol";
import "../../src/libraries/Libraries.sol";

contract MatchSystemTest is MudV2Test {
  function testStart() public {
    setUp();
    fillBodies();
    world.moving_castles_MatchSystem_start();
    assertTrue(Active.get(world, MatchKey));
    assertEq(StartBlock.get(world, MatchKey), block.number);
    assertEq(Health.get(world, BodyOne), 100);
    assertEq(Health.get(world, BodyTwo), 100);
  }

  function testEnd() public {
    setUp();
    fillBodies();
    world.moving_castles_MatchSystem_start();
    assertEq(MatchIndex.get(world, MatchKey), 0);
    // Set body two's health to 0
    world.moving_castles_DevSystem_set(HealthTableId, BodyTwo, abi.encodePacked(uint32(0)));
    world.moving_castles_MatchSystem_end();
    // ...
    assertTrue(!Active.get(world, MatchKey));
    assertEq(MatchIndex.get(world, MatchKey), 1);
    // ...
    bytes32 coreEntity = LibUtils.addressToEntityKey(alice);
    assertEq(CarriedBy.get(world, coreEntity), 0);
    assertEq(Points.get(world, coreEntity), 1);
    assertEq(RoundIndex.get(world, coreEntity), 0);
  }

  function testNuke() public {
    setUp();
    fillBodies();
    world.moving_castles_MatchSystem_start();
    assertEq(MatchIndex.get(world, MatchKey), 0);
    // FF
    vm.roll(block.number + MAX_MATCH_DURATION + 1);
    // Match is expired, nuke it
    vm.startPrank(xavier);
    world.moving_castles_MatchSystem_nuke();
    vm.stopPrank();
    // Game should be over
    assertTrue(!Active.get(world, MatchKey));
    assertEq(MatchIndex.get(world, MatchKey), 1);
    // Nuker should be rewarded
    assertEq(Points.get(world, LibUtils.addressToEntityKey(xavier)), 5);
    // ...
    assertEq(Points.get(world, LibUtils.addressToEntityKey(alice)), 0);
  }

  function testRevertNotOver() public {
    setUp();
    fillBodies();
    world.moving_castles_MatchSystem_start();
    vm.expectRevert(bytes("not over"));
    world.moving_castles_MatchSystem_end();
  }

  function testRevertNotEnoughPlayers() public {
    setUp();
    vm.expectRevert(bytes("not enough players"));
    world.moving_castles_MatchSystem_start();
  }
}
