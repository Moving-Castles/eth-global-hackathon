<script lang="ts">
  import Body from "../../components/Bodies/Body.svelte"
  import HealthBar from "../../components/Void/HealthBar.svelte"
  import Votes from "../../components/Void/Votes.svelte"
  import { setContext, getContext } from "svelte"
  import { entities, matchSingleton } from "../../modules/entities"
  import { playerAddress } from "../../modules/player"
  import { network } from "../../modules/network"
  import { WorldFunctions } from "../../modules/actionSequencer"
  import { onMount } from "svelte"
  import { lore } from "../../modules/lore"

  export let id: number
  export let joined: boolean
  export let active: boolean

  const icons = {
    0: id === 1 ? "game-icons:abstract-010" : "game-icons:abstract-033", // NONE
    1: id === 1 ? "game-icons:alligator-clip" : "game-icons:alligator-clip", // ATTACK_ONE
    2: id === 1 ? "game-icons:3d-hammer" : "game-icons:3d-hammer", // ATTACK_TWO
    3: id === 1 ? "game-icons:magick-trick" : "game-icons:magick-trick", // ATTACK_THREE
    4: id === 1 ? "game-icons:health-potion" : "game-icons:health-potion", // HEAL
    5: id === 1 ? "game-icons:anarchy" : "game-icons:anarchy", // TAUNT
  }

  setContext("icons", icons)
  const bodyOneCores = getContext("bodyOneCores")
  const bodyTwoCores = getContext("bodyTwoCores")

  $: bodyCores = id === 1 ? bodyOneCores : bodyTwoCores
  $: playerVote = $entities[$playerAddress]?.vote

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
  class:opponent={!$bodyCores.map(([k, _]) => k).includes($playerAddress)}
  class:mine={$bodyCores.map(([k, _]) => k).includes($playerAddress)}
>
  <div class="body-container">
    <Body
      {joined}
      {active}
      mine={$bodyCores.map(([k, _]) => k).includes($playerAddress)}
      ready={$bodyCores.length === $matchSingleton?.coresPerBody}
      id={id === 1 ? "BODY_ONE" : "BODY_TWO"}
    />
  </div>
  <div>
    {#if active}
      <HealthBar {id} />
      <div
        class="name"
        style:left={id === 1 ? '20px' : 'auto'}
        style:right={id === 2 ? '20px' : 'auto'}
      >
        {lore[id === 1 ? "governance_models_P1" : "governance_models_P2"][0]}
      </div>
    {/if}
  </div>

  {#if !active}
    <div class="statistics">
      {#if $bodyCores.length < $matchSingleton?.coresPerBody}
        <div class="statistics-content">
          <div class="statistics-content-main">
            {$matchSingleton?.coresPerBody - $bodyCores.length} spots left
          </div>
          {#if !joined && $bodyCores.length < $matchSingleton?.coresPerBody}
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
  {:else if $bodyCores.map(([k, v]) => k).includes($playerAddress)}
    <Votes {id} {playerVote} />
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
