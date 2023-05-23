<script lang="ts">
  import { network } from "../../modules/network"
  import { derived } from "svelte/store"
  import { setContext } from "svelte"
  import {
    entities,
    cores,
    matchSingleton,
    ActionType,
  } from "../../modules/entities"
  import { WorldFunctions } from "../../modules/actionSequencer"
  import { playerAddress } from "../../modules/player"
  // import copy from "copy-to-clipboard"
  import OffChain from "../../components/OffChain/OffChain.svelte"
  import Pane from "../../components/Void/Pane.svelte"
  // import Body from "../../components/Bodies/Body.svelte"
  import { onMount } from "svelte"

  const BODY_ONE =
    "0x0000000000000000000000000000000000000000000000000000000000000001"
  const BODY_TWO =
    "0x0000000000000000000000000000000000000000000000000000000000000002"

  let socket
  let cheerTimeout: number
  let cheering = false
  let gameOver = false
  let blink = false
  let interval = setInterval(() => (blink = !blink), 800)

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

  // b1c
  const bodyOneCores = derived(cores, $c => {
    const coreEntities = Object.entries($c)
    if (coreEntities.length) {
      return coreEntities.filter(([k, v]) => v.carriedBy === BODY_ONE)
    } else {
      return []
    }
  })

  // b2c
  const bodyTwoCores = derived(cores, $c => {
    const coreEntities = Object.entries($c)
    if (coreEntities.length) {
      return coreEntities.filter(([k, v]) => v.carriedBy === BODY_TWO)
    } else {
      return []
    }
  })

  // blc
  const bodilessCores = derived(cores, $c => {
    const coreEntities = Object.entries($c)
    if (coreEntities.length) {
      return coreEntities.filter(
        ([k, v]) => v.carriedBy !== BODY_ONE && v.carriedBy !== BODY_TWO
      )
    } else {
      return []
    }
  })

  // All bodies
  const bodyCores = derived([bodyOneCores, bodyTwoCores], ([$b1c, $b2c]) => [
    ...$b1c,
    ...$b2c,
  ])

  $: joined = $bodyCores.map(([k, v]) => k).includes($playerAddress)
  $: ready =
    $bodyOneCores.length === $matchSingleton?.coresPerBody &&
    $bodyTwoCores.length === $matchSingleton?.coresPerBody
  $: playerVote = $entities[$playerAddress]?.vote
  $: if (playerVote) {
    console.log(playerVote)
    console.log(ActionType[playerVote])
  }
  $: active = $matchSingleton?.active
  $: {
    gameOver = $entities["0x01"]?.health == 0 || $entities["0x02"]?.health == 0
  }

  function reset() {
    active = false
  }

  function cheer() {
    clearTimeout(cheerTimeout)
    cheering = true
    cheerTimeout = setTimeout(() => {
      cheering = false
    }, 1000)
  }

  function startMatch() {
    $network.worldSend(WorldFunctions.Start, [])
  }

  function endMatch() {
    $network.worldSend(WorldFunctions.End, [])
    reset()
  }

  function vote(action: ActionType) {
    $network.worldSend(WorldFunctions.Vote, [action])
  }

  // Set context
  setContext("bodyOneCores", bodyOneCores)
  setContext("bodyTwoCores", bodyTwoCores)
  setContext("bodyCores", bodyCores)
  setContext("bodilessCores", bodilessCores)
  setContext("vote", vote)

  onMount(() => {
    socket = new WebSocket("wss://mc.rttskr.com")

    socket.addEventListener("message", processCheer)

    playerVote = $entities[$playerAddress].vote
  })
</script>

<svelte:head>
  <title>
    {active
      ? `FIGHT | ${$cores[$playerAddress].name}`
      : `LOBBY | ${$cores[$playerAddress].name}`}
  </title>
</svelte:head>

<div class="void" class:active class:cheering>
  {#if active}
    <!-- <img class="overlay-r" src="/neubauten.png" /> -->
    <!-- <img class="overlay-l" src="/neubauten-2.png" /> -->
  {/if}

  <div>
    <!-- PLAYER ONE -->
    <Pane id={1} {active} {joined} />

    <!-- PLAYER TWO -->
    <Pane id={2} {active} {joined} />

    <!-- INSTRUCTIONS, META -->
    <div class="pane-mid-top">
      {#if !joined && !ready && !active}
        Pick a side, {$cores[$playerAddress].name}
      {/if}
      {#if ready && !joined}
        {#if $bodilessCores.length > 0}
          Spectators: <br />
          {#each $bodilessCores as spectator}
            {spectator[1].name}
            {#if spectator[0] === $playerAddress}(YOU){/if} <br />
          {/each}
        {/if}
      {/if}
      {#if active}
        {#if blink}VOTE TO WIN{/if}
      {/if}
    </div>

    <!-- ACTIONS, META -->
    <div class="pane-mid-bottom">
      {#if !active}
        {#if ready}
          <button
            disabled={$bodilessCores.includes($playerAddress)}
            on:click={startMatch}>START</button
          >
          <!-- {:else}
          <button on:click={invite}>INVITE</button> -->
        {/if}
      {:else if gameOver && active}
        <button on:click={endMatch}>END</button>
      {/if}

      {#if active && $bodilessCores.map(([k, v]) => k).includes($playerAddress)}
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
    background: lightgrey;
    color: black;
  }
</style>
