<script lang="ts">
  import { cores, playerAddress } from "../../modules/state"
  import type { Core } from "../../modules/state/types"
  import { verifiedClients } from "../../modules/signal"

  function sortObjectByPoints(obj: { [key: string]: Core }) {
    const sortedArray = Object.entries(obj).sort(
      (a, b) => b[1].points - a[1].points
    )
    const sortedObject: { [key: string]: Core } = {}
    for (const [key, value] of sortedArray) {
      sortedObject[key] = value
    }
    return sortedObject
  }
</script>

<div class="leaderboard">
  <strong>
    {$verifiedClients.length} core{$verifiedClients.length > 1 ? "s" : ""} online
  </strong>
  <hr />
  <ol>
    {#each Object.entries(sortObjectByPoints($cores)) as [key, core]}
      <li>
        {core.name}
        {#if key === $playerAddress}(YOU){/if}
        {#if $verifiedClients.includes(key)}(ONLINE){/if}
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
    color: white;
    background: darkblue;
    padding: 15px;
    /* height: 100px;
    overflow: scroll; */
  }

  ol,
  li {
    list-style-position: inside;
    margin: 0;
    padding: 0;
  }
</style>
