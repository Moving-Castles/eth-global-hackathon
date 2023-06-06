/*
 *  Central store for all entities in the game.
 * 
 */
import { writable, derived } from "svelte/store";
import { network, blockNumber } from "../network";
import type {
  MatchSingleton,
  Core,
  Body,
  Entities,
  Cores,
} from "./types";
import { ActionType } from "../action";

// --- CONSTANTS --------------------------------------------------------------

export const BODY_ONE = "0x0000000000000000000000000000000000000000000000000000000000000001"
export const BODY_TWO = "0x0000000000000000000000000000000000000000000000000000000000000002"

// --- STORES -----------------------------------------------------------------

// Mirror of the on chain state.
// Only ever written to via the update systems in /svelte/systems
export const entities = writable({} as Entities);

export const cores = derived(entities, ($entities) => {
  return Object.fromEntries(Object.entries($entities).filter(([, entity]) => entity.core)) as Cores;
});

export const bodies = derived(entities, ($entities) => {
  return {
    [1]: $entities["0x01"] as Body,
    [2]: $entities["0x02"] as Body,
  }
});

export const matchSingleton = derived(entities, ($entities) => {
  return $entities["0x0666"] as MatchSingleton;
});

// *** BODIES -----------------------------------------------------------------

export const coresInBodies = derived(cores, $cores => {
  const coreEntities = Object.entries($cores)
  return {
    [1]: coreEntities.length > 0 ? coreEntities.filter(([_, value]) => value.carriedBy === BODY_ONE) : [],
    [2]: coreEntities.length > 0 ? coreEntities.filter(([_, value]) => value.carriedBy === BODY_TWO) : []
  }
});

export const freeCores = derived(cores, $cores => {
  const coreEntities = Object.entries($cores)
  return coreEntities.length > 0 ? coreEntities.filter(
    ([, value]) => ![BODY_ONE, BODY_TWO].includes(value.carriedBy)) : []
})

export const cooldownOnBodies = derived([blockNumber, bodies], ([$blockNumber, $bodies]) => {
  return {
    [1]: Number($bodies[1].readyBlock) - Number($blockNumber),
    [2]: Number($bodies[2].readyBlock) - Number($blockNumber),
  }
})

// *** PLAYER -----------------------------------------------------------------

export const playerAddress = derived(network,
  $network => $network.network?.connectedAddress.get() || "0x0");

export const playerCore = derived([cores, playerAddress],
  ([$cores, $playerAddress]) => $cores[$playerAddress] as Core
);

export const isPlayerBody = derived([playerCore],
  ([$playerCore]) => {
    return {
      [1]: $playerCore.carriedBy === BODY_ONE,
      [2]: $playerCore.carriedBy === BODY_TWO,
    }
  })

// True if the local player has joined a body
export const playerJoinedBody = derived([playerCore],
  ([$playerCore]) => [BODY_ONE, BODY_TWO].includes($playerCore.carriedBy))

// Player voted when their own roundIndex is larger than the body's
export const playerHasVoted = derived([playerCore, entities],
  ([$playerCore, $entities]) =>
    $playerCore.roundIndex > ($entities[$playerCore.carriedBy]?.roundIndex || 0)
)

// The current action the player has voted for, set before executed on-chain
export const playerAction = writable(ActionType.NONE);

// *** GAME STATE -------------------------------------------------------------

// True if both bodies have reached the required number of cores
export const bodiesReady = derived([coresInBodies, matchSingleton],
  ([$coresInBodies, $matchSingleton]) => {
    return $coresInBodies[1].length === $matchSingleton?.coresPerBody
      && $coresInBodies[2].length === $matchSingleton?.coresPerBody
  })

// True if match is in progress
export const matchActive = derived(matchSingleton,
  $matchSingleton => $matchSingleton?.active)

// All votes are in when the cores roundIndeces are all same as body's
// export const allVotesAreIn = derived([bodies, coresInBodies],
//   ([$bodies, $coresInBodies]) => {
//     return {
//       [1]: $coresInBodies[1]
//         .map(([_, core]) => core.roundIndex)
//         .every(roundIndex => roundIndex === $bodies[1].roundIndex),
//       [2]: $coresInBodies[2]
//         .map(([_, core]) => core.roundIndex)
//         .every(roundIndex => roundIndex === $bodies[2].roundIndex),
//     }
//   })

// True if either body has 0 health
export const matchOver = derived(entities,
  $entities => {
    return $entities["0x01"]?.health == 0 || $entities["0x02"]?.health == 0
  })

// True if 60 block (1 minute) have passed since match started
// TODO: change to 600 (10 minutes) for production
export const matchExpired = derived([matchSingleton, blockNumber],
  ([$matchSingleton, $blockNumber]) => Number($matchSingleton?.startBlock) + 61 < Number($blockNumber))

// Return the winning entity
// If it's a tie, return no entities
// If the match is not over, return no entities
export const matchWinner = derived([matchOver, bodies],
  ([$matchOver, $bodies]) => {
    if ($matchOver) {
      if ($bodies[1].health > $bodies[2].health) return BODY_ONE
      if ($bodies[2].health > $bodies[1].health) return BODY_TWO
    }
    return false
  })

// *** PLAYER -----------------------------------------------------------------

// export enum WorldState {
//   WAITING_FOR_PLAYERS,
//   READY_TO_START,
//   MATCH_IN_PROGRESS,
//   MATCH_OVER,
//   MATCH_EXPIRED
// }

// export enum WorldEvent {
//   FILLED,
//   START,
//   KILL,
//   TIMEOUT,
//   END,
//   NUKE
// }

// export const worldState = writable({} as WorldState);

// export function transitionWorld(state: WorldState, event: WorldEvent) {
//   switch (state) {
//     case WorldState.WAITING_FOR_PLAYERS:
//       if (event === WorldEvent.FILLED) {
//         worldState.set(WorldState.READY_TO_START);
//         return true;
//       }
//     case WorldState.READY_TO_START:
//       if (event === WorldEvent.START) {
//         worldState.set(WorldState.MATCH_IN_PROGRESS);
//         return true;
//       }
//     case WorldState.MATCH_IN_PROGRESS:
//       if (event === WorldEvent.KILL) {
//         worldState.set(WorldState.MATCH_OVER);
//         return true;
//       }
//       if (event === WorldEvent.TIMEOUT) {
//         worldState.set(WorldState.MATCH_EXPIRED);
//         return true;
//       }
//     case WorldState.MATCH_OVER:
//       if (event === WorldEvent.END) {
//         worldState.set(WorldState.WAITING_FOR_PLAYERS);
//         return true;
//       }
//     case WorldState.MATCH_EXPIRED:
//       if (event === WorldEvent.NUKE) {
//         worldState.set(WorldState.WAITING_FOR_PLAYERS);
//         return true;
//       }
//     default:
//       return false;
//   }
// }

// export const playerState = writable({} as PlayerState);
// export enum PlayerState {
//   UNSPAWNED,
//   FREE,
//   IN_BODY
// }

