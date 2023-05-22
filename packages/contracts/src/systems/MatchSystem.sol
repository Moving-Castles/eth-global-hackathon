// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;
import { System } from "@latticexyz/world/src/System.sol";
import { Health, Active, CoresPerBody, ReadyBlock, Governance, Taunt } from "../codegen/Tables.sol";
import { GovernanceType } from "../codegen/Types.sol";
import { LibUtils, LibBody } from "../libraries/Libraries.sol";
import { BodyOne, BodyTwo, MatchKey } from "../constants.sol";

contract MatchSystem is System {
  function init() public {
    require(CoresPerBody.get(MatchKey) == 0, "already initialized");
    // ...
    Active.set(MatchKey, false);
    CoresPerBody.set(MatchKey, 2);
    Health.set(BodyOne, 100);
    Health.set(BodyTwo, 100);
    Governance.set(BodyOne, GovernanceType.NONE);
    Governance.set(BodyTwo, GovernanceType.NONE);
    Taunt.set(BodyOne, 0);
    Taunt.set(BodyTwo, 0);
  }

  function start() public {
    require(Active.get(MatchKey) == false, "match already active");
    require(
      LibBody.getCores(BodyOne).length == CoresPerBody.get(MatchKey) &&
        LibBody.getCores(BodyOne).length == CoresPerBody.get(MatchKey),
      "not enough players"
    );
    // ...
    Active.set(MatchKey, true);
    Health.set(BodyOne, 100);
    Health.set(BodyTwo, 100);
    Governance.set(BodyOne, GovernanceType.DEMOCRACY);
    Governance.set(BodyTwo, GovernanceType.DEMOCRACY);
    ReadyBlock.set(BodyOne, block.number);
    ReadyBlock.set(BodyTwo, block.number);
  }

  function end() public {
    require(Active.get(MatchKey) == true, "match ended");
    require(Health.get(BodyOne) == 0 || Health.get(BodyTwo) == 0, "not over");
    // ...
    Active.set(MatchKey, false);
    // ...
    LibBody.resetVotes(BodyOne);
    LibBody.resetVotes(BodyTwo);
    // ...
    LibBody.emptyBody(BodyOne);
    LibBody.emptyBody(BodyTwo);
    // ...
    // TODO: Calculated points per core
  }
}
