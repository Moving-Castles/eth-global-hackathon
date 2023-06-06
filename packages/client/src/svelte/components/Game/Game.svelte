<script lang="ts">
  import { onMount } from "svelte"
  import { initSignalNetwork } from "../../modules/signal"
  import {
    playerCore,
    matchActive,
    playerJoinedBody,
    bodiesReady,
    matchOver,
  } from "../../modules/state"
  import { cheering } from "../../modules/signal"

  import Cursors from "../Cursors/Cursors.svelte"
  import Pane from "../Pane/Pane.svelte"
  import LeaderBoard from "../LeaderBoard/LeaderBoard.svelte"
  import Presence from "../Presence/Presence.svelte"
  import Audience from "../Audience/Audience.svelte"
  import Results from "../Results/Results.svelte"
  import StartButton from "./StartButton.svelte"
  import EndButton from "./EndButton.svelte"
  import NukeButton from "./NukeButton.svelte"

  let cheerTimeout: NodeJS.Timeout

  $: if ($cheering) {
    clearTimeout(cheerTimeout)
    cheerTimeout = setTimeout(() => {
      cheering.set(false)
    }, 1000)
  }

  // We have to wait until the chains state is loaded and the player is spawned
  onMount(initSignalNetwork)
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

{#if !$matchActive}
  <LeaderBoard />
{/if}

<!-- Off chain signaling -->
<Presence />
<Cursors />

<div class="game" class:active={$matchActive} class:cheering={$cheering}>
  <div>
    <!-- BODY ONE -->
    <Pane id={1} />

    <!-- BODY TWO -->
    <Pane id={2} />

    <!-- MID-TOP -->
    <div class="mid-top">
      <!-- Waiting for players -->
      {#if !$playerJoinedBody && !$bodiesReady && !$matchActive}
        Pick a side, {$playerCore.name}
      {/if}

      <!-- Match in progress -->
      {#if $matchActive}
        {#if $playerJoinedBody}
          <!-- Player is in match -->
          VOTE TO WIN
        {:else}
          <!-- Player is audience -->
          <Audience />
        {/if}
      {/if}
    </div>

    <!-- MID-BOTTOM -->
    <div class="mid-bottom">
      <!-- Bodies filled, ready to start -->
      {#if !$matchActive && $bodiesReady}
        <StartButton />
      {/if}
      <!-- Match over, ready to end -->
      {#if $matchOver && $matchActive}
        <EndButton />
      {/if}
    </div>

    {#if $matchOver && $matchActive}
      <!-- RESULTS MODAL -->
      <Results />
    {/if}
  </div>
</div>

<style lang="scss">
  .game {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: #000000;
    display: flex;
    justify-content: center;
    align-items: center;
    font-size: 18px;

    .summary {
      position: fixed;
      inset: 0;
      z-index: 99;
      padding: 4rem;
      // background-color: rgba(0, 0, 0, 0.7);
      display: flex;
      flex-flow: column nowrap;
      justify-content: space-between;
      align-items: center;
    }

    .mid-top {
      position: fixed;
      left: 50%;
      top: 10%;
      background: red;
      transform: translateX(-50%);
      font-size: 32px;
    }

    .mid-bottom {
      position: fixed;
      left: 50%;
      top: 50%;
      background: red;
      transform: translateX(-50%) translateY(-50%);
      z-index: 9;
    }

    &.active {
      // background: orangered;
      background-image: url("/stage.png");
      background-size: contain;
      background-position: center;
      // background-repeat: no-repeat;
    }
  }
</style>
