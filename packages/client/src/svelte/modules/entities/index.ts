/*
 *  Central store for all entities in the game.
 * 
 */
import { writable, derived } from "svelte/store";

// --- TYPES -----------------------------------------------------------------

export enum ActionType {
  NONE,
  ATTACK_ONE,
  ATTACK_TWO,
  BLOCK,
  TAUNT,
  CHARGE
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
  taunt?: string;
  coresPerBody?: number;
};

export type MatchSingleton = {
  active: boolean;
  coresPerBody: number;
}

export type Core = {
  core: boolean;
  readyBlock: number;
  name: string;
  energy: number;
  points: number;
  carriedBy: string;
  vote: ActionType;
};

export type Body = {
  health: number;
  governance: GovernanceType;
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
  return Object.fromEntries(Object.entries($entities).filter(([key, entity]) => entity.core)) as Cores;
});

export const matchSingleton = derived(entities, ($entities) => {
  return $entities["0x0666"] as MatchSingleton;
});