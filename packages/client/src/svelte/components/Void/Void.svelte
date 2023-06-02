<script lang="ts">
  import {
    cores,
    playerAddress,
    playerCore,
    freeCores,
    matchActive,
    playerJoinedBody,
    bodiesReady,
    bodyCores,
    matchOver,
  } from "../../modules/state"
  import { start, end } from "../../modules/action"
  import { sendCheer, cheering } from "../../modules/signal"

  import OffChain from "../../components/OffChain/OffChain.svelte"
  import Pane from "../../components/Void/Pane.svelte"
  import NukeButton from "../NukeButton/NukeButton.svelte"
  import MinimalExecutor from "../Executor/MinimalExecutor.svelte"

  let cheerTimeout: NodeJS.Timeout
  let blink = false

  $: if ($cheering) {
    clearTimeout(cheerTimeout)
    cheerTimeout = setTimeout(() => {
      cheering.set(false)
    }, 1000)
  }

  $: joined = $bodyCores.map(([k]) => k)

  $: console.log(joined, $playerAddress)
  $: console.log($playerJoinedBody)
</script>

<svelte:head>
  <title>
    {$matchActive
      ? `FIGHT | ${$playerCore.name}`
      : `LOBBY | ${$playerCore.name}`}
  </title>
</svelte:head>

{#if $matchActive}
  <NukeButton />
{/if}

<div class="executor">
  <MinimalExecutor />
</div>

<div class="void" class:active={$matchActive} class:cheering={$cheering}>
  <div>
    <!-- BODY ONE -->
    <Pane id={1} />

    <!-- BODY TWO -->
    <Pane id={2} />

    <!-- INSTRUCTIONS, META -->
    <div class="pane-mid-top">
      {#if !$playerJoinedBody && !$bodiesReady && !$matchActive}
        Pick a side, {$cores[$playerAddress].name}
      {/if}
      {#if $bodiesReady && !$playerJoinedBody}
        {#if $freeCores.length > 0}
          Spectators: <br />
          {#each $freeCores as spectator}
            {spectator[1].name}
            {#if spectator[0] === $playerAddress}(YOU){/if} <br />
          {/each}
        {/if}
      {/if}
      {#if $matchActive}
        {#if blink}VOTE TO WIN{/if}
      {/if}
    </div>

    <!-- ACTIONS, META -->
    <div class="pane-mid-bottom">
      {#if !$matchActive}
        {#if $bodiesReady}
          <button
            disabled={$freeCores.includes($playerAddress)}
            on:click={start}>START</button
          >
        {/if}
      {:else if $matchOver && $matchActive}
        <button on:click={end}>END</button>
      {/if}
      {#if $matchActive && $freeCores
          .map(([k, v]) => k)
          .includes($playerAddress)}
        <button on:click={sendCheer}>CHEER</button>
      {/if}
    </div>

    <div class="info">
      <OffChain />
    </div>
  </div>
</div>

<style lang="scss">
  .void {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: #0000ff;
    display: flex;
    justify-content: center;
    align-items: center;
    font-size: 18px;

    &.active {
      // background: orangered;
      background-image: url("/stage.png");
      background-size: contain;
      background-position: center;
    }
  }

  .overlay-l {
    position: fixed;
    left: 0;
    bottom: 0;
    z-index: 9;
    width: 45vw;
    pointer-events: none;
  }

  .overlay-r {
    position: fixed;
    right: 0;
    bottom: 0;
    z-index: 9;
    width: 45vw;
    pointer-events: none;
  }

  button {
    font-size: 32px;
    display: block;
  }

  .pane-mid-top {
    position: fixed;
    left: 50%;
    top: 10%;
    background: red;
    transform: translateX(-50%);
    font-size: 32px;
  }

  .pane-mid-bottom {
    position: fixed;
    left: 50%;
    bottom: 10%;
    background: red;
    transform: translateX(-50%);
    z-index: 9;
  }

  .info {
    position: fixed;
    top: 5px;
    right: 5px;
    font-size: 11px;
    padding: 5px;
  }

  .executor {
    position: fixed;
    top: 0;
    left: 0;
    z-index: 10000;
  }
</style>
