// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.17;
import { console } from "forge-std/console.sol";
import { MudV2Test } from "../MudV2Test.t.sol";
import { BodyOne, BodyTwo, MatchKey } from "../../src/constants.sol";
import "../../src/codegen/Tables.sol";
import "../../src/libraries/Libraries.sol";

contract MatchSystemTest is MudV2Test {
  function testStart() public {
    setUp();
    fillBodies();
    world.moving_castles_MatchSystem_start();
    assertTrue(Active.get(world, MatchKey));
    assertEq(Health.get(world, BodyOne), 100);
    assertEq(Health.get(world, BodyTwo), 100);
  }

  function testEnd() public {
    setUp();
    fillBodies();
    world.moving_castles_MatchSystem_start();
    // Set body two's health to 0
    world.moving_castles_DevSystem_set(HealthTableId, BodyTwo, abi.encodePacked(uint32(0)));
    world.moving_castles_MatchSystem_end();
    assertTrue(!Active.get(world, MatchKey));
    bytes32 coreEntity = LibUtils.addressToEntityKey(alice);
    assertEq(CarriedBy.get(world, coreEntity), 0);
    console.log(Points.get(world, coreEntity));
    assertEq(Points.get(world, coreEntity), 1);
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
