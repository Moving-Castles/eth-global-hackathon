<script lang="ts">
  import { ActionType } from "../../modules/gameState"
  import { delayedTweened } from "../../modules/stores"
  import { getContext } from "svelte"
  import { tweened } from "svelte/motion"
  export let actionType: string


  // Import state
  const id = getContext('id')
  const body = getContext('body')
  const cores = getContext('cores')
  const vote = getContext("vote")  
  const increment = 1 / $cores.length

  $: roundIndex = $body?.roundIndex || 0
  $: voted = roundIndex !== $playerCore.roundIndex
  $: votesForThis = $cores.filter(([_, c]) => c.vote === ActionType[actionType])
  $: readyBlock = $body.readyBlock
  $: cooldownTime = Number(readyBlock) - Number($blockNumber)

  const progress = tweened(0, { duration: 200 })

  const voteThis = () => {
    vote(ActionType[actionType])
  }

  $: $progress = votesForThis.length * increment

  $: if (cooldownTime === -1) {
    // console.log('reset now')
  }
</script>


<div class="button" class:disabled={voted || cooldownTime > -1} on:click={voteThis}>
  <!-- {voted} {votedFirstRound} -->
  <!-- Round index: {roundIndex}<br> -->
  <!-- core votes: {coreVotesForThisAction}<br> -->
  <!-- core votes: {coreVotes} -->
  <!-- cores amount: {$cores.length} -->


  <img class="image {actionType}" src="/icons/{actionType}.png" alt={actionType} >
  <div class="progress" style:height="{$progress * 100}%" style:background-color={id === 1 ? '#0f0' : '#f00' } />
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