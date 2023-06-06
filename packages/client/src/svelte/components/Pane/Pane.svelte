<script lang="ts">
  import {
    matchSingleton,
    coresInBodies,
    playerJoinedBody,
    matchActive,
    matchOver,
    isPlayerBody,
    cooldownOnBodies,
  } from "../../modules/state"
  import HealthBar from "./HealthBar.svelte"
  import Body from "../../components/Body/Body.svelte"
  import Actions from "./Actions.svelte"
  import Votes from "./Votes.svelte"
  import PlayerItem from "./PlayerItem.svelte"
  import JoinButton from "./JoinButton.svelte"
  import CooldownOverlay from "./CoolDownOverlay.svelte"
  export let id: 1 | 2
</script>

<!-- svelte-ignore a11y-click-events-have-key-events -->
<div
  class="pane pane-{id}"
  class:active={$matchActive}
  class:lobby={!$matchActive}
  class:joined={$playerJoinedBody}
  class:opponent={!$isPlayerBody[id]}
  class:mine={$isPlayerBody[id]}
>
  {#if $cooldownOnBodies[id] > 0}
    <CooldownOverlay {id} />
  {/if}

  <div class="player-list">
    {#if !$matchActive}
      <!-- SPOT COUNTER -->
      <div class="spot-counter">
        {$matchSingleton?.coresPerBody - $coresInBodies[id].length} spots left
      </div>
    {/if}

    <!-- PLAYER LIST -->
    {#each $coresInBodies[id] as [_, core] (core)}
      <PlayerItem {core} />
    {/each}

    <!-- SUBMITTED VOTES -->
    {#if $matchActive}
      <Votes {id} />
    {/if}
  </div>

  <!-- BODY -->
  <div class="body-container">
    <Body {id} />
  </div>

  {#if $matchActive}
    <div>
      <!-- HEALTH -->
      <HealthBar {id} />
      <!-- ACTIONS -->
      {#if $isPlayerBody[id] && !$matchOver}
        <Actions {id} />
      {/if}
    </div>
  {/if}

  {#if !$playerJoinedBody}
    <div class="statistics">
      <!-- Body is full -->
      {#if $coresInBodies[id].length >= $matchSingleton?.coresPerBody}
        <div class="statistics-content statistics-content-main">READY</div>
      {:else}
        <!-- Spot available -->
        <div class="statistics-content">
          {#if !$playerJoinedBody}
            <JoinButton {id} />
          {/if}
        </div>
      {/if}
    </div>
  {/if}
</div>

<style lang="scss">
  .pane-1 {
    left: 0;
    background: #00ff00;
  }

  .pane-2 {
    right: 0;
    background: #ff0000;
  }

  .pane-2.active,
  .pane-1.active {
    background: transparent;
  }

  .pane.lobby.joined.opponent {
    filter: saturate(50%);
  }

  .pane {
    width: 50%;
    height: 100vh;
    display: flex;
    flex-flow: column;
    gap: 3rem;
    justify-content: space-between;
    align-items: center;
    position: fixed;
    top: 0;
    padding: 1rem;
    font-family: var(--font-family);

    &.active {
      background: transparent !important;
    }
  }

  .body-container {
    width: 80%;
    margin: 0 auto;
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    z-index: -1;
  }

  .statistics {
    align-self: start;
    text-align: center;
    display: flex;
    justify-content: center;
    margin: 0 auto;

    .statistics-content {
      color: black;
      background: white;
      width: auto;
      margin: 0 auto;
      display: flex;
      align-items: center;
      flex-shrink: 1;
      font-size: 3rem;
    }

    .statistics-content-main {
      padding: 12px 20px;
    }
  }

  .spot-counter {
    background: black;
    color: white;
    padding: 10px;
    border-radius: 5px;
  }
</style>
