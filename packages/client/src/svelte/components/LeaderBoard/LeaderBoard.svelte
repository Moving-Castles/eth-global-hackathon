<script lang="ts">
  import { cores, playerAddress } from "../../modules/state"
  import { verifiedClients } from "../../modules/signal"
  //TODO: order cores by points
</script>

<div class="leaderboard">
  <strong>
    {$verifiedClients.length} core{$verifiedClients.length > 1 ? "s" : ""} present
  </strong>
  <hr />
  <ol>
    {#each Object.entries($cores) as [key, core]}
      <li>
        {core.name}
        {#if key === $playerAddress}(YOU){/if}
        {#if $verifiedClients.includes(key)}*{/if}
        : <strong>{core.points || 0}</strong>
      </li>
    {/each}
  </ol>
</div>

<style>
  .leaderboard {
    top: 0;
    right: 0;
    position: fixed;
    z-index: 10000;
    pointer-events: none;
    flex-wrap: wrap;
    color: white;
    background: darkblue;
    padding: 15px;
  }

  ol,
  li {
    list-style-position: inside;
    margin: 0;
    padding: 0;
  }
</style>
