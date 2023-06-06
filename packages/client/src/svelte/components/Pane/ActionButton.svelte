<script lang="ts">
  import { vote, ActionType } from "../../modules/action"
  import {
    playerAction,
    cooldownOnBodies,
    playerHasVoted,
  } from "../../modules/state"
  import { playSound } from "../../modules/sound"
  import ActionIcon from "./ActionIcon.svelte"

  export let id: 1 | 2
  export let actionType: ActionType

  function sendVote() {
    playSound("tekken", "select")
    playerAction.set(actionType)
    vote(actionType)
  }

  // Player selected this action
  let selected = false
  $: selected = $playerAction === actionType

  // Player selected another action
  let disabled = false
  $: disabled =
    $playerAction !== ActionType.NONE && $playerAction !== actionType

  // Body is in cooldown
  let cooldown = false
  $: cooldown = $cooldownOnBodies[id] > 0

  // Player has voted in round
  let voted = false
  $: voted = $playerHasVoted
</script>

<!-- svelte-ignore a11y-click-events-have-key-events -->
<div
  class="action"
  class:selected
  class:disabled
  class:cooldown
  class:voted
  on:click={sendVote}
>
  <ActionIcon {actionType} />
</div>

<style lang="scss">
  .action {
    overflow: hidden;
    border-radius: 100%;
    aspect-ratio: 1;
    display: flex;
    justify-content: center;
    align-items: center;
    width: 5vw;
    cursor: pointer;
    background: rgba(255, 255, 255, 0.5);

    &:hover {
      background: orange;
    }

    &.selected {
      background: red;
    }

    &.disabled {
      pointer-events: none;
      background: rgba(255, 255, 255, 0.5);
      opacity: 0.3;
    }

    &.cooldown {
      pointer-events: none;
      background: rgba(255, 255, 255, 0.5);
      opacity: 0.3;
    }

    // &.voted {
    //   pointer-events: none;
    //   opacity: 0.3;
    // }
  }
</style>
