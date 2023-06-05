<script lang="ts">
  import { slide } from "svelte/transition"
  import { cores, playerAddress } from "../../modules/state"
  import { verifiedClients } from "../../modules/signal"
  import { playSound } from "../../modules/sound"
  import { TimelineMax } from "gsap"

  let expanded = false
  function togglePresence() {
    expanded = !expanded
    playSound("tekken", "select")
  }

  let toggleEl: HTMLElement
  function flash(color: string) {
    const tl2 = new TimelineMax()
    tl2.to(toggleEl, 0, { backgroundColor: color })
    tl2.to(toggleEl, 0.8, { backgroundColor: "rgba(211, 211, 211, 0.8)" })
  }

  let verifiedClientsCount = 0
  $: {
    if ($verifiedClients.length > verifiedClientsCount) {
      playSound("tekken", "honk")
      flash("rgba(0, 255, 0, 0.8)")
    }

    if ($verifiedClients.length < verifiedClientsCount) {
      playSound("tekken", "no")
      flash("rgba(255, 0, 0, 0.8)")
    }

    verifiedClientsCount = $verifiedClients.length
  }
</script>

<!-- svelte-ignore a11y-click-events-have-key-events -->
<div
  class="presence-toggle"
  bind:this={toggleEl}
  class:expanded
  on:click={togglePresence}
>
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
    background: rgba(211, 211, 211, 0.8);
    border-radius: 50%;
    height: 40px;
    width: 40px;
    text-align: center;
    line-height: 38px;
    cursor: pointer;
    font-size: 18px;

    &.expanded {
      background: rgba(211, 211, 211, 1);
    }
  }

  .presence {
    top: 50px;
    right: 25px;
    position: fixed;
    z-index: 10000;
    color: black;
    background: rgba(211, 211, 211, 0.8);
    padding: 15px;
  }

  ul,
  li {
    list-style-position: inside;
    margin: 0;
    padding: 0;
  }
</style>
