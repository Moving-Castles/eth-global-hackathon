<script lang="ts">
  import { matchExpired, matchSingleton } from "../../modules/state"
  import { blockNumber } from "../../modules/network"
  import { nuke } from "../../modules/action"
</script>

<div class="nuke">
  {#if $matchExpired}
    <button on:click={nuke}>NUKE</button>
  {:else}
    {Number($matchSingleton.startBlock) + 61 - Number($blockNumber)}
  {/if}
</div>

<style>
  .nuke {
    position: fixed;
    top: 10px;
    left: 50%;
    transform: translateX(-50%);
    width: 200px;
    height: 100px;
    background: black;
    display: flex;
    justify-content: center;
    align-items: center;
    z-index: 10000;
  }
</style>
