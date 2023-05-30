<script lang="ts">
  import { getContext } from "svelte"
  import { playerCore } from "../../modules/state"
  import { vote, ActionType } from "../../modules/action"
  import { tweened } from "svelte/motion"
  import { quintIn as easing } from "svelte/easing"
  export let actionType: string

  const id = getContext("id")
  const body = getContext("body")
  const cores = getContext("cores")
  const cooldown = getContext("cooldown")
  const progress = tweened(0, { duration: 200, easing })

  // Player voted when their own roundIndex is larger than the body's
  $: playerVoted = $playerCore.roundIndex > $body.roundIndex
  // All votes are in when the cores roundIndeces are all same as body's
  $: allVotesAreIn = $cores
    .map(([_, core]) => core.roundIndex)
    .every(roundIndex => roundIndex === $body.roundIndex)
  // Get the unfiltered count of votes
  $: count = $cores
    .map(([_, core]) => core.vote)
    .filter(v => v === ActionType[actionType]).length
  // Get the count of votes filtered by those who already voted
  $: filteredCount = $cores
    .filter(([_, core]) => core.roundIndex !== $body.roundIndex)
    .map(([_, core]) => core.vote)
    .filter(v => v === ActionType[actionType]).length

  // Only set the unfiltered count when we are in cooldown
  // NB: Doing this when “allVotesAreIn” would give us the wrong result bc it would also show the previous round's votes in the next one
  $: progress.set(($cooldown < 0 ? filteredCount : count) / $cores.length)

  // Reset to 0 when cooldown is over
  $: if ($cooldown < 0 && allVotesAreIn) progress.set(0)
</script>

<!-- svelte-ignore a11y-click-events-have-key-events -->
<div
  class:disabled={playerVoted || $cooldown > -1}
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
    style:background-color={id === 1 ? "var(--player1)" : "var(--player2)"}
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
    width: 5vw;
    cursor: pointer;
    background-color: rgba(255, 255, 255, 0.5);
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
