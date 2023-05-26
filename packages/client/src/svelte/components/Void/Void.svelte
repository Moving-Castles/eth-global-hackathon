<script lang="ts">
  import { onMount } from "svelte"
  import {
    cores,
    playerAddress,
    playerCore,
    freeCores,
    matchActive,
    playerJoinedBody,
    bodiesReady,
    matchOver,
  } from "../../modules/state"
  import { start, end } from "../../modules/action"

  import OffChain from "../../components/OffChain/OffChain.svelte"
  import Pane from "../../components/Void/Pane.svelte"

  let socket: any
  let cheerTimeout: NodeJS.Timeout
  let cheering = false
  let blink = false

  // => move to signal layer
  // -----------

  function sendCheer() {
    const message = JSON.stringify({ topic: "cheer" })
    cheer()
    socket.send(message)
  }

  function processCheer(event) {
    let msgObj = JSON.parse(event.data)
    if (msgObj.topic === "cheer") {
      cheer()
    }
  }

  function cheer() {
    clearTimeout(cheerTimeout)
    cheering = true
    cheerTimeout = setTimeout(() => {
      cheering = false
    }, 1000)
  }

  onMount(() => {
    socket = new WebSocket("wss://mc.rttskr.com")
    socket.addEventListener("message", processCheer)
  })

  // -----------
</script>

<svelte:head>
  <title>
    {$matchActive
      ? `FIGHT | ${$playerCore.name}`
      : `LOBBY | ${$playerCore.name}`}
  </title>
</svelte:head>

<div class="void" class:active={$matchActive} class:cheering>
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
        <button on:click={sendCheer}> CHEER </button>
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
</style>
