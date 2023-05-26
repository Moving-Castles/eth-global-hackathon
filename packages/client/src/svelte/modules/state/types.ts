import { ActionType } from "../action";

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

export type Entities = {
  [index: string]: Entity;
};

export type Cores = {
  [index: string]: Core;
};