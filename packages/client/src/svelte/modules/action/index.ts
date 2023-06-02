import { addToSequencer } from "./actionSequencer";
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
    addToSequencer(WorldFunctions.Start)
}

export function end() {
    addToSequencer(WorldFunctions.End);
}

export function nuke() {
    addToSequencer(WorldFunctions.Nuke)
}

export function vote(action: ActionType) {
    addToSequencer(WorldFunctions.Vote, [action])
}

export function join(i: 1 | 2) {
    addToSequencer(WorldFunctions.Join, [i])
}

export function spawn(name: string) {
    addToSequencer(WorldFunctions.Spawn, [name])
}