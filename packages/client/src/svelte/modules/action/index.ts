import { get } from "svelte/store";
import { network } from "../network"

export enum WorldFunctions {
    Spawn = "moving_castles_SpawnSystem_spawn",
    Join = "moving_castles_JoinSystem_join",
    Start = "moving_castles_MatchSystem_start",
    End = "moving_castles_MatchSystem_end",
    Nuke = "moving_castles_MatchSystem_nuke",
    Vote = "moving_castles_VoteSystem_vote",
}

export enum ActionType {
    NONE,
    ATTACK_ONE,
    ATTACK_TWO,
    ATTACK_THREE,
    HEAL,
    TAUNT
}

export const actionTypeStrings = [
    ...Array(Object.keys(ActionType).length / 2).keys(),
]

// --- API --------------------------------------------------------------

export function start() {
    get(network).worldSend(WorldFunctions.Start, [])
}

export function end() {
    get(network).worldSend(WorldFunctions.End, [])
}

export function nuke() {
    get(network).worldSend(WorldFunctions.Nuke, [])
}

export function vote(action: ActionType) {
    get(network).worldSend(WorldFunctions.Vote, [action])
}

export function join(i: 1 | 2) {
    get(network).worldSend(WorldFunctions.Join, [i])
}

export function spawn(name: string) {
    get(network).worldSend(WorldFunctions.Spawn, [name])
}