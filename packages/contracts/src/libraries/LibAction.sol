// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;
// import { getKeysWithValue } from "@latticexyz/world/src/modules/keyswithvalue/getKeysWithValue.sol";
// import { getKeysInTable } from "@latticexyz/world/src/modules/keysintable/getKeysInTable.sol";
import { ActionType } from "../codegen/Types.sol";
import { BodyOne, BodyTwo } from "../constants.sol";
import { Health, Vote } from "../codegen/Tables.sol";
import { LibBody } from "./LibBody.sol";

library LibAction {
  function execute(bytes32 _bodyEntity) internal {
    ActionType result = LibAction.countVotes(_bodyEntity);
    // If no decisive result, punish self
    if (result == ActionType.NONE) {
      attack(_bodyEntity);
    }

    if (result == ActionType.ATTACK) {
      bytes32 targetBodyEntity = _bodyEntity == BodyOne ? BodyTwo : BodyOne;
      attack(targetBodyEntity);
    }

    if (result == ActionType.BLOCK) {
      // TODO: !!!
    }

    if (result == ActionType.TAUNT) {
      // TODO: !!!
    }
  }

  // TODO: Find a better way of doing this
  function countVotes(bytes32 _bodyEntity) internal view returns (ActionType result) {
    bytes32[] memory cores = LibBody.getCores(_bodyEntity);
    ActionType[] memory votes = new ActionType[](cores.length);
    for (uint256 i = 0; i < cores.length; i++) {
      votes[i] = Vote.get(cores[i]);
    }

    ActionType mostCommonValue = votes[0];
    uint mostCommonCount = 0;
    bool isTie = false;

    for (uint i = 0; i < votes.length; i++) {
      uint count = 0;
      for (uint j = 0; j < votes.length; j++) {
        if (votes[j] == votes[i]) count++;
      }
      if (count > mostCommonCount) {
        mostCommonCount = count;
        mostCommonValue = votes[i];
        isTie = false;
      } else if (count == mostCommonCount) {
        isTie = true;
      }
    }

    return isTie ? ActionType.NONE : mostCommonValue;
  }

  //   ...

  function attack(bytes32 _targetBodyEntity) internal {
    Health.set(_targetBodyEntity, Health.get(_targetBodyEntity) - 10);
  }
}
