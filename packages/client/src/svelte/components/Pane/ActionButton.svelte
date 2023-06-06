<script lang="ts">
  import { playerCore } from "../../modules/state"
  import { vote, ActionType } from "../../modules/action"
  import { playSound } from "../../modules/sound"

  export let id: 1 | 2
  export let actionType: string

  let voteInProgress = false

  function sendVote() {
    if (voteInProgress) return
    voteInProgress = true
    playSound("tekken", "select")
    vote(ActionType[actionType])
  }

  $: if ($playerCore.roundIndex) {
    voteInProgress = false
  }
</script>

<!-- svelte-ignore a11y-click-events-have-key-events -->
<div class="action" class:active={voteInProgress} on:click={sendVote}>
  <img
    class="image {actionType}"
    src="/icons/{actionType}.png"
    alt={actionType}
  />
  <div class="background" />
</div>

<style lang="scss">
  .action {
    overflow: hidden;
    border-radius: 100%;
    aspect-ratio: 1;
    display: block;
    position: relative;
    width: 5vw;
    cursor: pointer;
    background: rgba(255, 255, 255, 0.5);

    &.active {
      background: red;
    }

    .image {
      mix-blend-mode: multiply;
      background-blend-mode: multiply;
      width: 75%;
      margin: 0 auto;
      position: absolute;
      top: 50%;
      left: 50%;
      transform: translate(-50%, -50%);
      z-index: 2;
    }

    .background {
      position: absolute;
      top: 0;
      left: 0;
      bottom: 0;
      right: 0;
      width: 100%;
      height: 100%;
    }

    &.HEAL {
      transform: translate(-50%, -50%) translate(0, 5%);
    }

    &.disabled {
      cursor: auto;
      pointer-events: none;
      background: #7a7a7a;
      .image {
        opacity: 0.2;
      }
    }
  }
</style>
