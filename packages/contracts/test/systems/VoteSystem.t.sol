// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.17;
import { console } from "forge-std/console.sol";
import { MudV2Test } from "../MudV2Test.t.sol";
import { ActionType } from "../../src/codegen/Types.sol";
import { BodyOne, BodyTwo, MatchKey } from "../../src/constants.sol";
import "../../src/codegen/Tables.sol";
import "../../src/libraries/Libraries.sol";

contract VoteSystemTest is MudV2Test {
  function testSingleVote() public {
    setUp();
    fillBodies();
    world.moving_castles_MatchSystem_start();

    assertTrue(Active.get(world, MatchKey));

    vm.startPrank(alice);
    world.moving_castles_VoteSystem_vote(ActionType.ATTACK_ONE);
    vm.stopPrank();

    bytes32 coreEntity = LibUtils.addressToEntityKey(alice);

    assertEq(uint32(Vote.get(world, coreEntity)), uint32(ActionType.ATTACK_ONE));
  }

  function testVote() public {
    setUp();
    fillBodies();
    world.moving_castles_MatchSystem_start();

    assertTrue(Active.get(world, MatchKey));

    vm.startPrank(alice);
    world.moving_castles_VoteSystem_vote(ActionType.ATTACK_ONE);
    vm.stopPrank();
    // assertEq(uint32(Vote.get(world, LibUtils.addressToEntityKey(alice))), uint32(ActionType.ATTACK_ONE));

    vm.startPrank(bob);
    world.moving_castles_VoteSystem_vote(ActionType.ATTACK_ONE);
    vm.stopPrank();

    // Vote complete, Action should be executed

    assertEq(uint32(LastAction.get(world, BodyOne)), uint32(ActionType.ATTACK_ONE));
    assertEq(Health.get(world, BodyOne), 100);
    assertEq(Health.get(world, BodyTwo), 90);
    assertEq(uint32(Vote.get(world, LibUtils.addressToEntityKey(alice))), uint32(ActionType.NONE));
    assertEq(uint32(Vote.get(world, LibUtils.addressToEntityKey(bob))), uint32(ActionType.NONE));
  }

  function testAttackTwo() public {
    setUp();
    fillBodies();
    world.moving_castles_MatchSystem_start();

    assertTrue(Active.get(world, MatchKey));

    vm.startPrank(alice);
    world.moving_castles_VoteSystem_vote(ActionType.ATTACK_TWO);
    vm.stopPrank();
    // assertEq(uint32(Vote.get(world, LibUtils.addressToEntityKey(alice))), uint32(ActionType.ATTACK_ONE));

    vm.startPrank(bob);
    world.moving_castles_VoteSystem_vote(ActionType.ATTACK_TWO);
    vm.stopPrank();

    // Vote complete, Action should be executed

    assertEq(Health.get(world, BodyOne), 90);
    assertEq(Health.get(world, BodyTwo), 70);
    assertEq(uint32(Vote.get(world, LibUtils.addressToEntityKey(alice))), uint32(ActionType.NONE));
    assertEq(uint32(Vote.get(world, LibUtils.addressToEntityKey(bob))), uint32(ActionType.NONE));
  }

  function testUnderflow() public {
    setUp();
    fillBodies();
    world.moving_castles_MatchSystem_start();

    assertTrue(Active.get(world, MatchKey));

    world.moving_castles_DevSystem_set(HealthTableId, BodyTwo, abi.encodePacked(uint32(20)));

    vm.startPrank(alice);
    world.moving_castles_VoteSystem_vote(ActionType.ATTACK_TWO);
    vm.stopPrank();

    vm.startPrank(bob);
    world.moving_castles_VoteSystem_vote(ActionType.ATTACK_TWO);
    vm.stopPrank();

    assertEq(Health.get(world, BodyOne), 90);
    assertEq(Health.get(world, BodyTwo), 0);
  }

  function testTaunt() public {
    setUp();
    fillBodies();
    world.moving_castles_MatchSystem_start();

    assertTrue(Active.get(world, MatchKey));

    vm.startPrank(alice);
    world.moving_castles_VoteSystem_vote(ActionType.TAUNT);
    vm.stopPrank();
    assertEq(uint32(Vote.get(world, LibUtils.addressToEntityKey(alice))), uint32(ActionType.TAUNT));

    vm.startPrank(bob);
    world.moving_castles_VoteSystem_vote(ActionType.TAUNT);
    vm.stopPrank();

    assertEq(Taunt.get(world, BodyOne), block.number);
  }

  function testFailedVote() public {
    setUp();
    fillBodies();
    world.moving_castles_MatchSystem_start();

    assertTrue(Active.get(world, MatchKey));

    vm.startPrank(alice);
    world.moving_castles_VoteSystem_vote(ActionType.ATTACK_ONE);
    vm.stopPrank();

    vm.startPrank(bob);
    world.moving_castles_VoteSystem_vote(ActionType.ATTACK_TWO);
    vm.stopPrank();

    // Vote complete, Action should have failed because of mismatch

    console.log("Health.get(world, BodyOne)");
    console.log(Health.get(world, BodyOne));

    console.log("Health.get(world, BodyTwo)");
    console.log(Health.get(world, BodyTwo));

    console.log("Vote.get(world, LibUtils.addressToEntityKey(alice)))");
    console.log(uint32(Vote.get(world, LibUtils.addressToEntityKey(alice))));

    console.log("Vote.get(world, LibUtils.addressToEntityKey(bob)))");
    console.log(uint32(Vote.get(world, LibUtils.addressToEntityKey(bob))));

    assertEq(Health.get(world, BodyOne), 90);
    assertEq(Health.get(world, BodyTwo), 100);
    assertEq(uint32(Vote.get(world, LibUtils.addressToEntityKey(alice))), uint32(ActionType.NONE));
    assertEq(uint32(Vote.get(world, LibUtils.addressToEntityKey(bob))), uint32(ActionType.NONE));
  }

  function testRevertInCooldown() public {
    setUp();
    fillBodies();
    world.moving_castles_MatchSystem_start();
    assertEq(ReadyBlock.get(world, BodyOne), block.number);

    assertTrue(Active.get(world, MatchKey));

    vm.startPrank(alice);
    world.moving_castles_VoteSystem_vote(ActionType.ATTACK_ONE);
    vm.stopPrank();

    vm.startPrank(bob);
    world.moving_castles_VoteSystem_vote(ActionType.ATTACK_ONE);
    vm.stopPrank();

    assertEq(ReadyBlock.get(world, BodyOne), block.number + 5);

    vm.startPrank(alice);
    vm.expectRevert(bytes("in cooldown"));
    world.moving_castles_VoteSystem_vote(ActionType.ATTACK_ONE);
    vm.stopPrank();
  }

  function testRevertNoGame() public {
    setUp();
    vm.startPrank(alice);
    world.moving_castles_SpawnSystem_spawn("Alice");
    vm.expectRevert(bytes("no match"));
    world.moving_castles_VoteSystem_vote(ActionType.ATTACK_ONE);
    vm.stopPrank();
  }

  function testRevertNotInBody() public {
    setUp();
    fillBodies();
    world.moving_castles_MatchSystem_start();
    vm.startPrank(xavier);
    world.moving_castles_SpawnSystem_spawn("Xavier");
    vm.expectRevert(bytes("not in body"));
    world.moving_castles_VoteSystem_vote(ActionType.ATTACK_ONE);
    vm.stopPrank();
  }
}
