<script lang="ts">
  import { freeCores, playerAddress } from "../../modules/state"
  import { sendCheer } from "../../modules/signal"
</script>

<div class="audience">
  Audience: <br />
  {#each $freeCores as spectator}
    {spectator[1].name}
    {#if spectator[0] === $playerAddress}(YOU){/if} <br />
  {/each}

  {#if $freeCores.map(([k]) => k).includes($playerAddress)}
    <button on:click={sendCheer}>CHEER</button>
  {/if}
</div>

<style lang="scss">
  .audience {
    position: fixed;
    top: 20%;
    left: 50%;
    transform: translateX(-50%) translateY(-50%);
    background: greenyellow;
    display: flex;
    justify-content: center;
    align-items: center;
    z-index: 10000000;
  }
</style>
