import { mudConfig } from "@latticexyz/world/register";
/**
 * Importing this enables "snap sync mode".
 * It allows clients to sync the latest state of the world using view functions.
 * This is a simple way to quickly sync without the use of an external indexer.
 * This could lead to expensive queries on live RPCs if the world is large,
 * so we suggest using MODE for production deployments.
 */
import "@latticexyz/world/snapsync";
import { resolveTableId } from "@latticexyz/config";

export default mudConfig({
    snapSync: true,
    deploysDirectory: "./deploys",
    namespace: "moving_castles",
    enums: {
        GovernanceType: ["NONE", "DEMOCRACY"],
        ActionType: ["NONE", "ATTACK_ONE", "ATTACK_TWO", "BLOCK", "TAUNT", "CHARGE"]
    },
    tables: {
        Core: "bool",
        CarriedBy: "bytes32",
        Name: "string",
        Energy: "uint32",
        Points: "uint32",
        ReadyBlock: "uint256",
        Health: "uint32",
        Active: "bool",
        Vote: "ActionType",
        Governance: "GovernanceType",
        CoresPerBody: "uint32",
        Taunt: {
            keySchema: {},
            schema: {
                taunter: "bytes32",
            },
            ephemeral: true,
        },
    },
    modules: [
        {
            name: "KeysWithValueModule",
            root: true,
            args: [resolveTableId("CarriedBy")],
        },
    ],
});
