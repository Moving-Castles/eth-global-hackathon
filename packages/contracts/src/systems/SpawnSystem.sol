// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;
import { System } from "@latticexyz/world/src/System.sol";
import { Core, Points, ReadyBlock, Name } from "../codegen/Tables.sol";
import { LibUtils } from "../libraries/Libraries.sol";

contract SpawnSystem is System {
  function spawn(string memory _name) public {
    bytes32 coreEntity = LibUtils.addressToEntityKey(_msgSender());
    require(!Core.get(coreEntity), "already spawned");
    // ...
    Core.set(coreEntity, true);
    Name.set(coreEntity, _name);
    ReadyBlock.set(coreEntity, block.number);
    Points.set(coreEntity, 0);
  }
}
