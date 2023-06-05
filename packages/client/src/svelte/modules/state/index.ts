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

export const matchSingleton = derived(entities, ($entities) => {
  return $entities["0x0666"] as MatchSingleton;
});

// *** BODIES -----------------------------------------------------------------

export const bodyOne = derived(entities, ($entities) => {
  return $entities["0x01"]
})

export const bodyTwo = derived(entities, ($entities) => {
  return $entities["0x02"]
})

export const bodyOneCores = derived(cores, $cores => {
  const coreEntities = Object.entries($cores)
  return coreEntities.length > 0 ? coreEntities.filter(([, value]) => value.carriedBy === BODY_ONE) : []
})

export const bodyTwoCores = derived(cores, $cores => {
  const coreEntities = Object.entries($cores)
  return coreEntities.length > 0 ? coreEntities.filter(([, value]) => value.carriedBy === BODY_TWO) : []
})

export const freeCores = derived(cores, $cores => {
  const coreEntities = Object.entries($cores)
  return coreEntities.length > 0 ? coreEntities.filter(
    ([, value]) => ![BODY_ONE, BODY_TWO].includes(value.carriedBy)) : []
})

export const bodyCores = derived([bodyOneCores, bodyTwoCores], ([$bodyOneCore, $bodyTwoCores]) => [
  ...$bodyOneCore,
  ...$bodyTwoCores,
])

// *** PLAYER -----------------------------------------------------------------

export const playerAddress = derived(network,
  $network => $network.network?.connectedAddress.get() || "0x0");

export const playerCore = derived([entities, playerAddress],
  ([$entities, $playerAddress]) => $entities[$playerAddress] as Core
);

export const playerBody = derived([entities, playerCore],
  ([$entities, $playerCore]) => {
    if (!$entities || !$playerCore) return {} as Body;
    return $entities[$playerCore.carriedBy] as Body;
  });

// *** GAME STATE -------------------------------------------------------------

// True if the local player has joined a body
export const playerJoinedBody = derived([bodyCores, playerAddress],
  ([$bodyCores, $playerAddress]) => $bodyCores.map(([key]) => key).includes($playerAddress))

// True if both bodies have reached the required number of cores
export const bodiesReady = derived([bodyOneCores, bodyTwoCores, matchSingleton],
  ([$bodyOneCores, $bodyTwoCores, $matchSingleton]) => {
    return $bodyOneCores.length === $matchSingleton?.coresPerBody
      && $bodyTwoCores.length === $matchSingleton?.coresPerBody
  })

// True if match is in progress
export const matchActive = derived(matchSingleton,
  $matchSingleton => $matchSingleton?.active)

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
export const matchWinner = derived([matchOver, bodyOne, bodyTwo],
  ([$matchOver, $bodyOne, $bodyTwo]) => {
    if ($matchOver) {
      if ($bodyOne.health > $bodyTwo.health) return BODY_ONE
      if ($bodyTwo.health > $bodyOne.health) return BODY_TWO
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

