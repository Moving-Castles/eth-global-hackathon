<script lang="ts">
  import { vote, ActionType } from "../../modules/action"
  import { delayedTweened } from "../../modules/ui/stores"
  import { tweened } from "svelte/motion"
  export let id: number
  export let actionType: string
  export let disabled: boolean
  export let progress: number

  const tweenedProgress = tweened(progress, 1000)

  const voteThis = () => vote(ActionType[actionType])

  $: tweenedProgress.set(progress)
</script>

<!-- svelte-ignore a11y-click-events-have-key-events -->
<div class:disabled class="button" on:click={voteThis}>
  <img
    class="image {actionType}"
    src="/icons/{actionType}.png"
    alt={actionType}
  />
  <div
    class="progress"
    style:height="{$tweenedProgress * 100}%"
    style:background-color={id === 1 ? "#0f0" : "#f00"}
  />
  <div class="background" />
</div>

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
