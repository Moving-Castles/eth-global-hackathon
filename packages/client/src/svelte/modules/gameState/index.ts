/*
 *  Central store for all entities in the game.
 * 
 */
import { writable, derived } from "svelte/store";
import { network } from "../network";

// --- TYPES -----------------------------------------------------------------

export enum ActionType {
  NONE,
  ATTACK_ONE,
  ATTACK_TWO,
  ATTACK_THREE,
  HEAL,
  TAUNT
}

export enum GovernanceType {
  NONE,
  DEMOCRACY
}

// Default type with all potential properties.
export type Entity = {
  core?: boolean;
  readyBlock?: number;
  energy?: number;
  name?: string;
  points?: number;
  carriedBy?: string;
  active?: boolean;
  health?: number;
  vote?: ActionType;
  governance?: GovernanceType;
  taunt?: number;
  coresPerBody?: number;
  lastAction?: ActionType;
  matchIndex?: number;
  roundIndex?: number;
};

export type MatchSingleton = {
  active: boolean;
  coresPerBody: number;
  matchIndex: number;
}

export type Core = {
  core: boolean;
  name: string;
  energy: number;
  points: number;
  carriedBy: string;
  vote: ActionType;
  roundIndex: number;
};

export type Body = {
  health: number;
  readyBlock: number;
  governance: GovernanceType;
  taunt: number;
  lastAction: ActionType;
  roundIndex: number;
}

// - - - -

export type Entities = {
  [index: string]: Entity;
};

export type Cores = {
  [index: string]: Core;
};

// --- STORES -----------------------------------------------------------------

export const entities = writable({} as Entities);

export const cores = derived(entities, ($entities) => {
  return Object.fromEntries(Object.entries($entities).filter(([, entity]) => entity.core)) as Cores;
});

// => SINGLETONS

export const matchSingleton = derived(entities, ($entities) => {
  return $entities["0x0666"] as MatchSingleton;
});

// => PLAYER

export const playerAddress = derived(network, ($network) => $network.network?.connectedAddress.get() || "0x0");

export const playerCore = derived(
  [entities, playerAddress],
  ([$entities, $playerAddress]) => $entities[$playerAddress] as Core
);

export const playerBody = derived([entities, playerCore], ([$entities, $playerCore]) => {
  if (!$entities || !$playerCore) return {} as Body;
  return $entities[$playerCore.carriedBy] as Body;
});

