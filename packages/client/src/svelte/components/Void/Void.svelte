<script lang="ts">
  import {
    cores,
    playerAddress,
    playerCore,
    freeCores,
    matchActive,
    matchWinner,
    playerJoinedBody,
    bodiesReady,
    matchOver,
    BODY_ONE,
  } from "../../modules/state"
  import { start, end } from "../../modules/action"
  import { sendCheer, cheering } from "../../modules/signal"
  import { playSound } from "../../modules/sound"
  import { lore } from "../../modules/content/lore"

  import Cursors from "../../components/Cursors/Cursors.svelte"
  import Pane from "../../components/Void/Pane.svelte"
  import NukeButton from "../NukeButton/NukeButton.svelte"
  import LeaderBoard from "../LeaderBoard/LeaderBoard.svelte"
  import Presence from "../Presence/Presence.svelte"
  import Ellipse from "../Ellipse/Ellipse.svelte"

  let cheerTimeout: NodeJS.Timeout
  let blink = false

  let startInProgess = false
  let endInProgress = false
  let winnerName = ""

  $: if ($matchWinner) {
    winnerName =
      $matchWinner === BODY_ONE
        ? lore.governance_models_P1[0]
        : lore.governance_models_P2[0]
  } else {
    winnerName = ""
  }

  $: if ($cheering) {
    clearTimeout(cheerTimeout)
    cheerTimeout = setTimeout(() => {
      cheering.set(false)
    }, 1000)
  }

  function sendStart() {
    if (startInProgess) return
    startInProgess = true
    playSound("tekken", "click")
    start()
  }

  function sendEnd() {
    if (endInProgress) return
    endInProgress = true
    playSound("tekken", "click")
    end()
  }

  // !!! HACK
  $: if ($matchActive) {
    startInProgess = false
    endInProgress = false
  }
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

<Presence />

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
            class="start-button pane-special"
            on:click={sendStart}
          >
            {#if startInProgess}
              <Ellipse />
            {:else}
              START
            {/if}
          </button>
        {/if}
      {/if}
      {#if $matchActive && $freeCores.map(([k]) => k).includes($playerAddress)}
        <button on:click={sendCheer}>CHEER</button>
      {/if}
    </div>

    {#if $matchOver && $matchActive}
      <div class="summary">
        <!-- RESULT MESSAGE -->
        <div class="pane-mid-top">
          {#if $matchWinner}
            {winnerName} wins!
          {:else}
            It's a tie!
          {/if}
        </div>

        <div class="pane-mid-bottom">
          <button class="button" on:click={sendEnd}>
            {#if endInProgress}
              <Ellipse />
            {:else}
              END
            {/if}
          </button>
        </div>
      </div>
    {/if}

    <div class="info">
      <Cursors />
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
    background: #000000;
    display: flex;
    justify-content: center;
    align-items: center;
    font-size: 18px;

    &.active {
      // background: orangered;
      background-image: url("/stage.png");
      background-size: contain;
      background-position: center;
      // background-repeat: no-repeat;
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
    top: 50%;
    background: red;
    transform: translateX(-50%) translateY(-50%);
    z-index: 9;
  }

  .info {
    position: fixed;
    top: 5px;
    right: 5px;
    font-size: 11px;
    padding: 5px;
  }

  .start-button {
    font-size: 48px;
    border: 0;
    padding: 20px 40px;
    width: 300px;
  }
</style>
