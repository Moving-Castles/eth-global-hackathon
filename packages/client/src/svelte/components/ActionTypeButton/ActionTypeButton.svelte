<script lang="ts">
  import { vote, ActionType } from "../../modules/action"
  import { delayedTweened } from "../../modules/ui/stores"
  import { tweened } from "svelte/motion"
  export let actionType: string

  const progress = tweened(0, { duration: 200 })

  $: $progress = votesForThis.length * increment

  $: if (cooldownTime === -1) {
    // console.log('reset now')
  }
</script>

<!-- svelte-ignore a11y-click-events-have-key-events -->
<div
  class:disabled
  class="button"
  on:click={() => {
    vote(ActionType[actionType])
  }}
>
  <img
    class="image {actionType}"
    src="/icons/{actionType}.png"
    alt={actionType}
  />
  <div
    class="progress"
    style:height="{$progress * 100}%"
    style:background-color={id === 1 ? "#0f0" : "#f00"}
  />
  <div class="background" />
</div>

<!-- <small>{$progress}</small> -->

<style>
  .button {
    overflow: hidden;
    border-radius: 100%;
    aspect-ratio: 1;
    display: block;
    position: relative;
    width: 80px;
    cursor: pointer;
    background-color: #fff;
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

  .HEAL {
    transform: translate(-50%, -50%) translate(0, 5%);
  }

  .disabled {
    cursor: auto;
    pointer-events: none;
    background: #7a7a7a;
  }

  .disabled .image {
    opacity: 0.2;
  }

  .progress {
    position: absolute;
    bottom: 0;
    width: 100%;
    z-index: 1;
  }
  .background {
    position: absolute;
    top: 0;
    left: 0;
    bottom: 0;
    right: 0;
    width: 100%;
    height: 100%;
    /* z-index: -2; */
  }
</style>
