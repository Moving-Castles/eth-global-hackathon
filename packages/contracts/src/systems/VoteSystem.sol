// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;
import { System } from "@latticexyz/world/src/System.sol";
import { Health, CarriedBy, Vote, Active } from "../codegen/Tables.sol";
import { ActionType } from "../codegen/Types.sol";
import { LibUtils, LibAction, LibBody } from "../libraries/Libraries.sol";
import { BodyOne, BodyTwo, MatchKey } from "../constants.sol";

contract VoteSystem is System {
  function vote(ActionType _action) public {
    bytes32 coreEntity = LibUtils.addressToEntityKey(_msgSender());
    bytes32 bodyEntity = CarriedBy.get(coreEntity);
    //...
    require(Active.get(MatchKey), "no match");
    require(bodyEntity == BodyOne || bodyEntity == BodyTwo, "not in body");
    require(Health.get(bodyEntity) > 0, "dead");
    require(Vote.get(coreEntity) == ActionType.NONE, "already voted");
    // ...
    Vote.set(coreEntity, _action);
    //...
    if (LibBody.voteComplete(bodyEntity)) {
      LibAction.execute(bodyEntity);
      LibBody.resetVotes(bodyEntity);
    }
  }
}
