// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;
// import { getKeysWithValue } from "@latticexyz/world/src/modules/keyswithvalue/getKeysWithValue.sol";
// import { getKeysInTable } from "@latticexyz/world/src/modules/keysintable/getKeysInTable.sol";
import { ActionType } from "../codegen/Types.sol";
import { BodyOne, BodyTwo } from "../constants.sol";
import { Health, Vote } from "../codegen/Tables.sol";
import { LibBody } from "./LibBody.sol";
import { console } from "forge-std/console.sol";

library LibAction {
  function execute(bytes32 _bodyEntity) internal {
    ActionType result = LibAction.countVotes(_bodyEntity);
    bytes32 targetBodyEntity = _bodyEntity == BodyOne ? BodyTwo : BodyOne;

    console.log("!!! RESULT");
    console.log(uint(result));

    // If no decisive result, punish self
    if (result == ActionType.NONE) {
      console.log("NONE");
      console.log(uint256(_bodyEntity));
      // Damage to self =  10
      Health.set(_bodyEntity, Health.get(_bodyEntity) - 10);
    }

    if (result == ActionType.ATTACK_ONE) {
      console.log("ATTACK ONE");
      // Damage to opponent =  10
      Health.set(targetBodyEntity, Health.get(targetBodyEntity) - 10);
    }

    if (result == ActionType.ATTACK_TWO) {
      console.log("ATTACK TWO");
      bytes32 targetBodyEntity = _bodyEntity == BodyOne ? BodyTwo : BodyOne;
      // Damage to opponent =  30
      Health.set(targetBodyEntity, Health.get(targetBodyEntity) - 30);
      // Damage to self =  10
      Health.set(_bodyEntity, Health.get(_bodyEntity) - 10);
    }

    if (result == ActionType.BLOCK) {
      console.log("BLOCK");
      // TODO: !!!
    }

    if (result == ActionType.TAUNT) {
      console.log("TAUNT");
      // TODO: !!!
    }

    if (result == ActionType.CHARGE) {
      console.log("CHARGE");
      // TODO: !!!
    }
  }

  // This function counts the votes for different actions and returns the action with maximum votes.
  // If there is a tie, it returns ActionType.NONE.
  function countVotes(bytes32 _bodyEntity) internal view returns (ActionType result) {
    // Fetch all the cores associated with the given body entity
    bytes32[] memory cores = LibBody.getCores(_bodyEntity);

    // Declare an array to store the votes associated with each core
    ActionType[] memory votes = new ActionType[](cores.length);

    // Declare an array to count the votes for each ActionType
    // The length is 6 because there are six ActionTypes:
    // - NONE
    // - ATTACK_ONE
    // - ATTACK_TWO
    // - BLOCK
    // - TAUNT
    // - CHARGE
    uint[] memory voteCounts = new uint[](6);

    // Declare a variable to keep track of the maximum vote count
    uint maxVoteCount = 0;

    // Loop over all the cores
    for (uint256 i = 0; i < cores.length; i++) {
      // Get the vote associated with the current core and store it in the votes array
      votes[i] = Vote.get(cores[i]);
    }

    // Loop over all the votes
    for (uint i = 0; i < votes.length; i++) {
      // Increment the count for the current vote
      voteCounts[uint(votes[i])]++;

      console.log("VOTE:");
      console.log(uint(votes[i]));

      // Get the count for the current vote
      uint voteCount = voteCounts[uint(votes[i])];

      console.log("VOTE COUNT:");
      console.log(voteCounts[uint(votes[i])]);

      // If the count for the current vote is greater than the maximum vote count seen so far
      if (voteCount > maxVoteCount) {
        console.log("NEW TOP");
        // Update the maximum vote count
        maxVoteCount = voteCount;

        // Update the result to the current vote
        result = votes[i];
      }
      // If the count for the current vote is equal to the maximum vote count
      else if (voteCount == maxVoteCount) {
        console.log("TIE");
        // There is a tie, so update the result to ActionType.NONE
        result = ActionType.NONE;
      }
    }

    // Return the result: the ActionType with the maximum vote count, or ActionType.NONE in case of a tie
    return result;
  }
}
