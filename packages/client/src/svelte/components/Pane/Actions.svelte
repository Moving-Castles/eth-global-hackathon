<script lang="ts">
  import { playerAction } from "../../modules/state"
  import { ActionType, WorldFunctions } from "../../modules/action"
  import { completedActions } from "../../modules/action/actionSequencer"
  import ActionButton from "./ActionButton.svelte"

  export let id: 1 | 2

  // Reset player action when vote is complete
  completedActions.subscribe(actions => {
    if (actions[0]?.systemId == WorldFunctions.Vote)
      playerAction.set(ActionType.NONE)
  })
</script>

<div
  class="actions"
  style:right={id === 1 ? "auto" : "40px"}
  style:left={id === 2 ? "auto" : "40px"}
>
  <ActionButton {id} actionType={ActionType.ATTACK_ONE} />
  <ActionButton {id} actionType={ActionType.ATTACK_TWO} />
  <ActionButton {id} actionType={ActionType.ATTACK_THREE} />
  <ActionButton {id} actionType={ActionType.HEAL} />
  <ActionButton {id} actionType={ActionType.TAUNT} />
</div>

<style>
  .actions {
    right: 40px;
    width: calc(50vw - 80px);
    bottom: 40px;
    display: flex;
    flex-flow: row nowrap;
    justify-content: center;
    align-items: center;
    gap: 20px;
    position: fixed;
    transition: opacity 0.1s ease;
  }
</style>
