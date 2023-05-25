<script lang="ts">
  import type { Core, Body as BodyType } from "../../modules/entities"
  import type { Derived } from "svelte/store"
  import Body from "../../components/Bodies/Body.svelte"
  import HealthBar from "../../components/Void/HealthBar.svelte"
  import Votes from "../../components/Void/Votes.svelte"
  import { setContext, getContext } from "svelte"
  import { entities, matchSingleton, playerAddress } from "../../modules/gameState"
  import { network, blockNumber } from "../../modules/network"
  import { WorldFunctions } from "../../modules/actionSequencer"
  import { onMount } from "svelte"
  import { lore } from "../../modules/lore"

  export let id: number
  export let joined: boolean
  export let active: boolean

  const bodyOneCores: Core[] = getContext("bodyOneCores")
  const bodyTwoCores: Core[] = getContext("bodyTwoCores")
  const body: Derived<BodyType[]> = derived(entities, ($ents) => $ents[id === 1 ? "0x01" : "0x02"])
  const cores: Derived<CoreType[]> = derived([bodyOneCores, bodyTwoCores], ([$b1c, $b2c]) => (id === 1 ? $b1c : $b2c))
  
  setContext('body', body)
  setContext('cores', cores)
  setContext('id', id)

  $: playerVote = $entities[$playerAddress]?.vote
  $: readyBlock = $body.readyBlock
  $: cooldownTime = Number(readyBlock) - Number($blockNumber)

  function joinBody(i: 1 | 2) {
    if (!joined) $network.worldSend(WorldFunctions.Join, [i])
  }

  onMount(() => {
    playerVote = $entities[$playerAddress]?.vote
  })
</script>

<!-- svelte-ignore a11y-click-events-have-key-events -->
<div
  class="pane pane-{id}"
  class:active
  class:lobby={!active}
  class:joined
  class:opponent={!$cores.map(([k, _]) => k).includes($playerAddress)}
  class:mine={$cores.map(([k, _]) => k).includes($playerAddress)}
>
  <div class="body-container">
    <Body
      {joined}
      {active}
      mine={$cores.map(([k, _]) => k).includes($playerAddress)}
      ready={$cores.length === $matchSingleton?.coresPerBody}
      id={id === 1 ? "BODY_ONE" : "BODY_TWO"}
    />
  </div>
  <div>
    {#if active}
      <HealthBar />
      <div
        class="name"
        style:text-align={id === 1 ? "left" : "right"}
        style:left={id === 1 ? '20px' : 'auto'}
        style:right={id === 2 ? '20px' : 'auto'}
      >
        {lore[id === 1 ? "governance_models_P1" : "governance_models_P2"][0]}<br>{#if cooldownTime > 0}{cooldownTime}{/if} roundindex: {$body.roundIndex}
      </div>
    {/if}
  </div>

  {#if !active}
    <div class="statistics">
      {#if $cores.length < $matchSingleton?.coresPerBody}
        <div class="statistics-content">
          <div class="statistics-content-main">
            {$matchSingleton?.coresPerBody - $cores.length} spots left
          </div>
          {#if !joined && $cores.length < $matchSingleton?.coresPerBody}
            <button
              class="statistics-button"
              on:click|once={() => joinBody(id)}
            >
              JOIN
            </button>
          {/if}
        </div>
      {:else}
        <div class="statistics-content statistics-content-main">READY</div>
      {/if}
    </div>
  {:else if $cores.map(([k, v]) => k).includes($playerAddress)}
    <Votes {id} {playerVote} {cooldownTime} />
  {/if}
</div>

<style>
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

  .pane.lobby.joined.mine {
    /* filter: saturate(500%); */
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
    padding: 3rem;
    transition: all 1s ease;

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

  .vote-counter {
    position: absolute;
    top: 0;
    font-size: 20rem;
  }

  .body-statistics {
    position: absolute;
    bottom: 0;
  }

  .statistics {
    align-self: start;
    text-align: center;
    display: flex;
    justify-content: center;
    margin: 0 auto;
  }

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
  .statistics-content-main,
  .statistics-button {
    padding: 12px 20px;
  }

  .statistics-button {
    color: white;
    background: black;
    font-size: 3rem;
  }

  .name {
    position: fixed;
    top: 80px;
  }
</style>
