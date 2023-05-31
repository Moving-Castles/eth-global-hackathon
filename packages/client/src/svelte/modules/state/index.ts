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

const BODY_ONE = "0x0000000000000000000000000000000000000000000000000000000000000001"
const BODY_TWO = "0x0000000000000000000000000000000000000000000000000000000000000002"

// --- STORES -----------------------------------------------------------------

export const entities = writable({} as Entities);

export const cores = derived(entities, ($entities) => {
  return Object.fromEntries(Object.entries($entities).filter(([, entity]) => entity.core)) as Cores;
});

export const matchSingleton = derived(entities, ($entities) => {
  return $entities["0x0666"] as MatchSingleton;
});

// *** BODIES -----------------------------------------------------------------

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
