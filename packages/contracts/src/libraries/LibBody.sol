// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;
import { getKeysWithValue } from "@latticexyz/world/src/modules/keyswithvalue/getKeysWithValue.sol";
import { CarriedBy, CarriedByTableId, Vote, Points, RoundIndex } from "../codegen/Tables.sol";
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
      // Cores is still in current round, vote not completed
      if (RoundIndex.get(cores[i]) == RoundIndex.get(_bodyEntity)) {
        return false;
      }
    }
    return true;
  }

  // function resetVotes(bytes32 _bodyEntity) internal {
  //   bytes32[] memory cores = getCores(_bodyEntity);
  //   for (uint256 i = 0; i < cores.length; i++) {
  //     Vote.set(cores[i], ActionType.NONE);
  //   }
  // }

  function emptyBody(bytes32 _bodyEntity) internal {
    bytes32[] memory cores = getCores(_bodyEntity);
    for (uint256 i = 0; i < cores.length; i++) {
      CarriedBy.set(cores[i], 0);
    }
  }

  function givePoints(bytes32 _bodyEntity) internal {
    bytes32[] memory cores = getCores(_bodyEntity);
    for (uint256 i = 0; i < cores.length; i++) {
      Points.set(cores[i], Points.get(cores[i]) + 1);
    }
  }
}
