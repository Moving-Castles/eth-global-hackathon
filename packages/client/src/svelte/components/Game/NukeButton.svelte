<script lang="ts">
  import { fade } from "svelte/transition"
  import { matchExpired, matchSingleton, matchOver } from "../../modules/state"
  import { blockNumber } from "../../modules/network"
  import { nuke } from "../../modules/action"
  import { playSound } from "../../modules/sound"

  let nukeInProgress = false

  function sendNuke() {
    if (nukeInProgress) return
    nukeInProgress = true
    playSound("tekken", "nuke")
    nuke()
  }
</script>

<div class="nuke">
  {#if $matchExpired && !$matchOver}
    <button class="button" on:click={sendNuke}>NUKE</button>
  {:else if !$matchOver}
    {Number($matchSingleton.startBlock) + 61 - Number($blockNumber)}
  {/if}
</div>

{#if nukeInProgress}
  <div class="overlay" in:fade={{ duration: 500 }} />
{/if}

<style lang="scss">
  .nuke {
    position: fixed;
    top: 50%;
    left: 50%;
    transform: translateX(-50%) translateY(-50%);
    background: black;
    display: flex;
    justify-content: center;
    align-items: center;
    z-index: 10000000;
  }

  .button {
    font-size: 48px;
    border: 0;
  }

  .overlay {
    position: fixed;
    top: 0;
    left: 0;
    width: 100vw;
    height: 100vh;
    background: white;
    z-index: 10000000;
  }
</style>
