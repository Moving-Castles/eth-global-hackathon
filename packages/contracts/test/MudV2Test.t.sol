// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;
import "forge-std/Test.sol";
import { IWorld } from "../src/codegen/world/IWorld.sol";

contract MudV2Test is Test {
  address worldAddress;
  IWorld world;

  address internal alice;
  address internal bob;
  address internal eve;
  address internal mallory;
  address internal xavier;

  function setUp() public virtual {
    worldAddress = vm.parseAddress("0x5FbDB2315678afecb367f032d93F642f64180aa3");
    world = IWorld(worldAddress);

    alice = address(111);
    bob = address(222);
    eve = address(333);
    mallory = address(444);
    xavier = address(555);
  }

  function fillBodies() public virtual {
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
    world.moving_castles_JoinSystem_join(2);
    vm.stopPrank();

    vm.startPrank(mallory);
    world.moving_castles_SpawnSystem_spawn("Mallory");
    world.moving_castles_JoinSystem_join(2);
    vm.stopPrank();
  }
}
