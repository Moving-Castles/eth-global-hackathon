<script lang="ts">
  import { network } from "../../modules/network"
  import { entities, ActionType } from "../../modules/entities"
  import { WorldFunctions } from "../../modules/actionSequencer"
  import { cores } from "../../modules/entities"
  import { playerAddress, playerCore } from "../../modules/player"
  import copy from "copy-to-clipboard"
  import Body from "../../components/Bodies/Body.svelte"

  const BODY_ONE =
    "0x0000000000000000000000000000000000000000000000000000000000000001"
  const BODY_TWO =
    "0x0000000000000000000000000000000000000000000000000000000000000002"
  const CORES_REQUIRED = 2

  $: bodyOneCores = Object.entries($cores).filter(([k, v]) => v.carriedBy === BODY_ONE)
  $: bodyTwoCores = Object.entries($cores).filter(([k, v]) => v.carriedBy === BODY_TWO)
  $: bodilessCores = Object.entries($cores).filter(([k, v]) => v.carriedBy !== BODY_ONE && v.carriedBy !== BODY_TWO)
  $: isBodyOne = joined && bodyOneCores.map(([k, v]) => k).includes($playerAddress)
  $: isBodyTwo = joined && bodyTwoCores.map(([k, v]) => k).includes($playerAddress)
  
  $: bodyCores = [...bodyOneCores, ...bodyTwoCores]
  $: joined = bodyCores.map(([k, v]) => k).includes($playerAddress)
  $: ready = bodyOneCores.length === 2 && bodyTwoCores.length === 2
  $: console.log($playerCore)

  let active = false
  let cheerTimeout
  let cheering = false

  const invite = () => copy(window.location.href);

  $: active = $entities["0x0666"]?.active

  let done = false
  $: {
    done = $entities["0x01"].health == 0 || $entities["0x02"].health == 0
  }

  function cheer () {
    clearTimeout(cheerTimeout)
    cheering = true
    cheerTimeout = setTimeout(() => {
      cheering = false
    }, 1000)
  }

  function joinBody(i: 1 | 2) {
    if (!joined) $network.worldSend(WorldFunctions.Join, [i])
  }

  function startMatch() {
    $network.worldSend(WorldFunctions.Start, [])
  }

  function endMatch() {
    $network.worldSend(WorldFunctions.End, [])
  }

  function vote(action: ActionType) {
    $network.worldSend(WorldFunctions.Vote, [action])
  }

  function attackOne() {
    vote(ActionType.ATTACK_ONE)
  }

  function attackTwo() {
    vote(ActionType.ATTACK_TWO)
  }

  function block() {
    vote(ActionType.BLOCK)
  }

  function taunt() {
    vote(ActionType.TAUNT)
  }
</script>

<div
  class="void"
  class:active
  class:cheering>

  {#if active}
    <img class="overlay-r" src="/neubauten.png">
    <img class="overlay-l" src="/neubauten-2.png">
  {/if}

  <div>
    <!-- ONE -->
    <!-- svelte-ignore a11y-click-events-have-key-events -->
    <div class="pane left" on:click={() => joinBody(1) }>
      <div class="body-container">
        <Body
          {joined}
          {active}
          ready={bodyOneCores.length === 2}
          id="BODY_ONE"
          mine={joined && isBodyOne}
        />
      </div>
      <div>
        <!-- <button on:click={() => joinBody(1) }>BODY 1</button> -->
        {#if active}
          <div>
            E: {$entities["0x01"]?.health}
          </div>
        {/if}
        {#each bodyOneCores as [key, value]}
          <div class="core">
            <div class="core__name">
              {$entities[key].name}
              {#if key === $playerAddress}(YOU){/if}
            </div>
          </div>
        {/each}
      </div>

      {#if !active}
        <div class="statistics">
          {#if bodyOneCores.length < 2}
            <div class="">
              {bodyOneCores.length} / {CORES_REQUIRED} Cores 
            </div>
          {:else}
            <div>
              READY
            </div>
          {/if}
        </div>
      {:else}
        <div class="votes">
          <button on:click={attackOne}>ATTACK I</button>
          <button on:click={attackTwo}>ATTACK II</button>
          <button on:click={taunt}>TAUNT</button>
        </div>
      {/if}

    </div>

    <!-- TWO -->
    <!-- svelte-ignore a11y-click-events-have-key-events -->
    <div class="pane right" on:click={() => joinBody(2) }>
      <div class="body-container">
        <Body
          {joined}
          {active}
          ready={bodyTwoCores.length === 2}
          mine={joined && isBodyTwo}
          id="BODY_TWO"
        />
      </div>
      <div>
        {#if active}
          <div>
            E: {$entities["0x02"]?.health}
          </div>
        {/if}
        {#each bodyTwoCores as [key, value]}
          <div class="core">
            <div class="core__name">
              {$entities[key].name}
              {#if key === $playerAddress}(YOU){/if}
            </div>
          </div>
        {/each}
      </div>

      {#if !active}
        <div class="statistics">
          {#if bodyTwoCores.length < 2}
            <div class="">
              {bodyTwoCores.length} / {CORES_REQUIRED} Cores 
            </div>
          {:else}
            <div>
                READY
            </div>
          {/if}
        </div>
      {:else}
        <div class="votes">
          <button on:click={attackOne}>ATTACK I</button>
          <button on:click={attackTwo}>ATTACK II</button>
          <button on:click={taunt}>TAUNT</button>
        </div>
      {/if}
    </div>

    <div class="mid-top">
      {#if !joined && !ready}
        Pick a body, {$entities[$playerAddress].name}
      {/if}
      {#if ready && !joined}
        {#if bodilessCores.length > 0}
          Spectators: <br>
          {#each bodilessCores as spectator}
          {$entities[spectator[0]].name} <br>
            <!-- {spectator[0]} -->
          {/each}
        {/if}
      {/if}
    </div>

    <div class="mid">
      {#if active}
        <!-- MATCH -->
      {:else}
        <!-- LOBBY -->
      {/if}

      {#if !active}
        {#if ready}
          <button on:click={startMatch}>START</button>
        {:else}
          <button on:click={invite}>INVITE</button>
        {/if}
      {:else if done}
        <button on:click={endMatch}>END</button>
      {/if}

      {#if active && (!bodyOneCores.map(([k, v]) => k).includes($playerAddress) && !bodyTwoCores.map(([k, v]) => k).includes($playerAddress))}
        <button on:click={cheer}>
          CHEER
        </button>
      {/if}
    </div>

    <!-- <div class="info">
      <hr />
      <div>ON CHAIN CORES:</div>
      {#each Object.entries($cores) as [key, value]}
        <div class="core">
          <div class="core__name">
            {key}
            {#if key === $playerAddress}(YOU){/if}
          </div>
        </div>
      {/each}
      <hr />
      <OffChain />
      <hr />
    </div> -->
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
      background: orangered;
      background-image: url('/worls.png');
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

  .body-container {
    width: 70%;
    margin: 0 auto;
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    z-index: -1;
  }

  .body-statistics {
    position: absolute;
  }

  button {
    font-size: 32px;
    display: block;
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
    padding: 3rem;

    &.left {
      left: 0;
    }
    &.right {
      right: 0;
      background: orange;
    }
  }

  .active .right {
    background: transparent;
  }

  .statistics {
    align-self: start;
  }

  .mid-top {
    position: fixed;
    left: 50%;
    top: 10%;
    background: red;
    transform: translateX(-50%);
  }
  .mid {
    position: fixed;
    left: 50%;
    bottom: 10%;
    background: red;
    transform: translateX(-50%);
  }

  .info {
    position: fixed;
    top: 5px;
    right: 5px;
    font-size: 9px;
    padding: 5px;
    background: lightgrey;
    color: black;
  }

  .cheering {
    animation: cheers 0.18s infinite;
    filter: invert(1);
  }

  @keyframes cheers {
    from {
      filter: invert(0);
    }
    to {
      filter: invert(1);
    }
  }
</style>
