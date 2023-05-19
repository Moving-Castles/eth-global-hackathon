// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

/* Autogenerated file. Do not edit manually. */

import { IBaseWorld } from "@latticexyz/world/src/interfaces/IBaseWorld.sol";

import { IAttackSystem } from "./IAttackSystem.sol";
import { IDevSystem } from "./IDevSystem.sol";
import { IJoinSystem } from "./IJoinSystem.sol";
import { IMatchSystem } from "./IMatchSystem.sol";
import { ISpawnSystem } from "./ISpawnSystem.sol";

/**
 * The IWorld interface includes all systems dynamically added to the World
 * during the deploy process.
 */
interface IWorld is IBaseWorld, IAttackSystem, IDevSystem, IJoinSystem, IMatchSystem, ISpawnSystem {

}
