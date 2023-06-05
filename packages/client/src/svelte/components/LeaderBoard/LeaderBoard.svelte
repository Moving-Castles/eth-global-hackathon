<script lang="ts">
  import { slide } from "svelte/transition"
  import { cores, playerAddress } from "../../modules/state"
  import type { Core } from "../../modules/state/types"
  import { verifiedClients } from "../../modules/signal"
  import { playSound } from "../../modules/sound"

  let expanded = false

  function toggleLeaderboard() {
    expanded = !expanded
    playSound("tekken", "select")
  }

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

<!-- svelte-ignore a11y-click-events-have-key-events -->
<div class="leaderboard-toggle" class:expanded on:click={toggleLeaderboard}>
  ✦
</div>

{#if expanded}
  <!-- svelte-ignore a11y-click-events-have-key-events -->
  <div
    class="leaderboard"
    transition:slide={{ duration: 200 }}
    on:click={toggleLeaderboard}
  >
    <strong>High Score</strong>
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
{/if}

<style lang="scss">
  .leaderboard-toggle {
    top: 5px;
    right: 50px;
    position: fixed;
    z-index: 10000;
    color: black;
    background: rgba(211, 211, 211, 0.8);
    border-radius: 50%;
    height: 40px;
    width: 40px;
    text-align: center;
    line-height: 38px;
    cursor: pointer;
    font-size: 38px;

    &.expanded {
      background: rgba(211, 211, 211, 1);
    }
  }

  .leaderboard {
    top: 50px;
    right: 70px;
    position: fixed;
    z-index: 10000;
    color: black;
    background: rgba(211, 211, 211, 0.8);
    padding: 15px;
  }

  ol,
  li {
    list-style-position: inside;
    margin: 0;
    padding: 0;
  }
</style>
