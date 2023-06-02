<script lang="ts">
  import { cores, playerAddress } from "../../modules/state"
  import { verifiedClients } from "../../modules/signal"
</script>

<!-- Presence box -->
<div class="leaderboard">
  <div>
    <strong>
      {$verifiedClients.length} wizard{$verifiedClients.length > 1 ? "s" : ""} present
    </strong>
  </div>
  <div>
    {#each $verifiedClients as client}
      <div>
        {$cores[client].name}
        {#if client === $playerAddress}(YOU){/if}
      </div>
    {/each}
  </div>
</div>

<style>
  .leaderboard {
    width: 40px;
    height: 40px;
    top: 0;
    right: 0;
    position: fixed;
    z-index: 10000;
    pointer-events: none;
    text-align: center;
    display: flex;
    justify-content: center;
    align-items: center;
    flex-wrap: wrap;
    color: white;
  }
</style>
