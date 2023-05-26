// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;
import { System } from "@latticexyz/world/src/System.sol";
import { Health, Active, CoresPerBody, Governance, MatchIndex } from "../codegen/Tables.sol";
import { GovernanceType, ActionType } from "../codegen/Types.sol";
import { LibUtils, LibBody } from "../libraries/Libraries.sol";
import { BodyOne, BodyTwo, MatchKey } from "../constants.sol";

contract MatchSystem is System {
  function init() public {
    require(CoresPerBody.get(MatchKey) == 0, "already initialized");
    // Initialize match
    Active.set(MatchKey, false);
    CoresPerBody.set(MatchKey, 2);
    MatchIndex.set(MatchKey, 0);
    // Initialize bodies
    LibBody.resetBody(BodyOne);
    LibBody.resetBody(BodyTwo);
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
    // ...
    Governance.set(BodyOne, GovernanceType.DEMOCRACY);
    Governance.set(BodyTwo, GovernanceType.DEMOCRACY);
  }

  function end() public {
    require(Active.get(MatchKey) == true, "match ended");
    require(Health.get(BodyOne) == 0 || Health.get(BodyTwo) == 0, "not over");
    // ...
    Active.set(MatchKey, false);
    MatchIndex.set(MatchKey, MatchIndex.get(MatchKey) + 1);
    // ...
    LibBody.givePoints(Health.get(BodyOne) == 0 ? BodyTwo : BodyOne);
    // ...
    LibBody.emptyBody(BodyOne);
    LibBody.emptyBody(BodyTwo);
    // ...
    LibBody.resetBody(BodyOne);
    LibBody.resetBody(BodyTwo);
  }
}
