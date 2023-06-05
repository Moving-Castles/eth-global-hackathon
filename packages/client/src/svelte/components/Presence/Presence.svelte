<script lang="ts">
  import { slide } from "svelte/transition"
  import { cores, playerAddress } from "../../modules/state"
  import { verifiedClients } from "../../modules/signal"

  let expanded = false
  function togglePresence() {
    expanded = !expanded
  }
</script>

<!-- svelte-ignore a11y-click-events-have-key-events -->
<div class="presence-toggle" on:click={togglePresence}>
  {$verifiedClients.length}
</div>

{#if expanded}
  <!-- svelte-ignore a11y-click-events-have-key-events -->
  <div
    class="presence"
    transition:slide={{ duration: 200 }}
    on:click={togglePresence}
  >
    <strong>
      {$verifiedClients.length} core{$verifiedClients.length > 1 ? "s" : ""} online
    </strong>
    <hr />
    <ul>
      {#each $verifiedClients as key}
        <li>
          {$cores[key].name}
          {#if key === $playerAddress}(YOU){/if}
        </li>
      {/each}
    </ul>
  </div>
{/if}

<style lang="scss">
  .presence-toggle {
    top: 5px;
    right: 5px;
    position: fixed;
    z-index: 10000;
    color: black;
    background: lightgray;
    border-radius: 50%;
    height: 40px;
    width: 40px;
    text-align: center;
    line-height: 38px;
    cursor: pointer;
    font-size: 18px;
  }

  .presence {
    top: 50px;
    right: 5px;
    position: fixed;
    z-index: 10000;
    color: black;
    background: rgba(211, 211, 211, 0.9);
    padding: 15px;
    border-radius: 5px;
  }

  ul,
  li {
    list-style-position: inside;
    margin: 0;
    padding: 0;
  }
</style>
