// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;
import { getKeysWithValue } from "@latticexyz/world/src/modules/keyswithvalue/getKeysWithValue.sol";
import { getKeysInTable } from "@latticexyz/world/src/modules/keysintable/getKeysInTable.sol";
import { CarriedBy, CarriedByTableId, Vote } from "../codegen/Tables.sol";
import { ActionType } from "../codegen/Types.sol";
import { BodyOne, BodyTwo } from "../constants.sol";

library LibBody {
  function getCores(bytes32 _bodyEntity) internal view returns (bytes32[] memory) {
    bytes32[] memory keysWithValue = getKeysWithValue(CarriedByTableId, CarriedBy.encode(_bodyEntity));
    return keysWithValue;
  }

  function voteComplete(bytes32 _bodyEntity) internal view returns (bool) {
    bytes32[] memory cores = getCores(_bodyEntity);
    for (uint256 i = 0; i < cores.length; i++) {
      if (Vote.get(cores[i]) == ActionType.NONE) {
        return false;
      }
    }
    return true;
  }

  function resetVotes(bytes32 _bodyEntity) internal {
    bytes32[] memory cores = getCores(_bodyEntity);
    for (uint256 i = 0; i < cores.length; i++) {
      Vote.set(cores[i], ActionType.NONE);
    }
  }

  function resetBodies() internal {
    bytes32[][] memory keys = getKeysInTable(CarriedByTableId);
    for (uint256 i = 0; i < keys.length; i++) {
      CarriedBy.deleteRecord(keys[i][0]);
    }
  }
}
