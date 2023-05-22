// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.17;
import { MudV2Test } from "../MudV2Test.t.sol";
import { BodyOne, BodyTwo } from "../../src/constants.sol";
import "../../src/codegen/Tables.sol";
import "../../src/libraries/Libraries.sol";

contract JoinSystemTest is MudV2Test {
  function testJoin() public {
    setUp();

    vm.startPrank(alice);
    world.moving_castles_SpawnSystem_spawn("Alice");
    vm.stopPrank();

    bytes32 coreEntity = LibUtils.addressToEntityKey(alice);

    vm.startPrank(alice);
    world.moving_castles_JoinSystem_join(1);
    vm.stopPrank();

    assertEq(CarriedBy.get(world, coreEntity), BodyOne);
  }

  function testRevertAlreadyCarried() public {
    setUp();

    vm.startPrank(alice);
    world.moving_castles_SpawnSystem_spawn("Alice");
    vm.stopPrank();

    vm.startPrank(alice);
    world.moving_castles_JoinSystem_join(2);

    vm.expectRevert(bytes("already carried"));
    world.moving_castles_JoinSystem_join(2);
    vm.stopPrank();
  }

  function testRevertInvalidBody() public {
    setUp();

    vm.startPrank(alice);
    world.moving_castles_SpawnSystem_spawn("Alice");
    vm.stopPrank();

    vm.startPrank(alice);
    vm.expectRevert(bytes("invalid body"));
    world.moving_castles_JoinSystem_join(3);
    vm.stopPrank();
  }

  function testRevertBodyFull() public {
    setUp();

    vm.startPrank(alice);
    world.moving_castles_SpawnSystem_spawn("Alice");
    world.moving_castles_JoinSystem_join(1);
    vm.stopPrank();

    vm.startPrank(bob);
    world.moving_castles_SpawnSystem_spawn("Bob");
    world.moving_castles_JoinSystem_join(1);
    vm.stopPrank();

    vm.startPrank(eve);
    world.moving_castles_SpawnSystem_spawn("Eve");
    vm.expectRevert(bytes("body is full"));
    world.moving_castles_JoinSystem_join(1);
    vm.stopPrank();
  }
}
