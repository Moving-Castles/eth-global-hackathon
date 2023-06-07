// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;
import { getKeysWithValue } from "@latticexyz/world/src/modules/keyswithvalue/getKeysWithValue.sol";
import { CarriedBy, CarriedByTableId, Vote, Points, RoundIndex, Taunt, Governance, Health, LastAction, ReadyBlock } from "../codegen/Tables.sol";
import { ActionType, GovernanceType } from "../codegen/Types.sol";
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

  function resetBody(bytes32 _bodyEntity) internal {
    Health.set(_bodyEntity, 100);
    RoundIndex.set(_bodyEntity, 0);
    Governance.set(_bodyEntity, GovernanceType.NONE);
    LastAction.set(_bodyEntity, ActionType.NONE);
    Taunt.set(_bodyEntity, 0);
    ReadyBlock.set(_bodyEntity, block.number);
  }

  function givePoints(bytes32 _bodyEntity) internal {
    bytes32[] memory cores = getCores(_bodyEntity);
    for (uint256 i = 0; i < cores.length; i++) {
      Points.set(cores[i], Points.get(cores[i]) + 1000);
    }
  }
}
