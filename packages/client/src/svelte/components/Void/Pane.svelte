<script lang="ts">
  import Body from "../../components/Bodies/Body.svelte"
  import HealthBar from "../../components/Void/HealthBar.svelte"
  import { getContext } from "svelte"
  import Icon from "@iconify/svelte"
  import { entities, matchSingleton, ActionType } from "../../modules/entities"
  import { playerAddress } from "../../modules/player"
  import { network } from "../../modules/network"
  import { WorldFunctions } from "../../modules/actionSequencer"
  import { onMount } from "svelte"

  export let id: number
  export let joined: boolean
  export let active: boolean

  const icons = {
    0: id === 1 ? "game-icons:abstract-010" : "game-icons:abstract-033", // NONE
    1: id === 1 ? "game-icons:alligator-clip" : "game-icons:afterburn", // ATTACK_ONE
    2: id === 1 ? "game-icons:3d-hammer" : "game-icons:ak47", // ATTACK_TWO
    4: id === 1 ? "game-icons:anarchy" : "game-icons:android-mask", // TAUNT
  }

  const bodyOneCores = getContext("bodyOneCores")
  const bodyTwoCores = getContext("bodyTwoCores")

  const vote = getContext("vote")

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
<div class="pane pane-{id}" class:active on:click={() => joinBody(id)}>
  {#if active}
    <div class="vote-counter">
      {#each $bodyCores as [k, entry]}
        <div
          class="vote"
          class:inactive={entry.vote === ActionType.NONE || !entry.vote}
        >
          <Icon icon={icons[entry.vote] || icons[0]} />
        </div>
      {/each}
    </div>
  {/if}

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
    {/if}
  </div>

  {#if !active}
    <div class="statistics">
      {#if $bodyCores.length < $matchSingleton?.coresPerBody}
        <div class="">
          {$bodyCores.length} / {$matchSingleton?.coresPerBody} Cores
        </div>
      {:else}
        <div>READY</div>
      {/if}
    </div>
  {:else if $bodyCores.map(([k, v]) => k).includes($playerAddress)}
    <div class="votes" class:disabled={!isNaN(playerVote) && playerVote !== 0}>
      <button
        class="vote-button"
        disabled={!isNaN(playerVote) && playerVote !== 0}
        on:click={attackOne}
      >
        ATTACK 1 <Icon icon={icons[1]} />
      </button>
      <button
        class="vote-button"
        disabled={!isNaN(playerVote) && playerVote !== 0}
        on:click={attackTwo}
      >
        ATTACK 2 <Icon icon={icons[2]} />
      </button>
      <button
        class="vote-button"
        disabled={!isNaN(playerVote) && playerVote !== 0}
        on:click={taunt}
      >
        TAUNT <Icon icon={icons[4]} />
      </button>
    </div>
  {/if}
</div>

<style>
  .pane-1 {
    left: 0;
  }
  .pane-2 {
    right: 0;
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

    &:nth-child(1) {
      left: 0;
    }
    &:nth-child(2) {
      right: 0;
    }

    &.active:nth-child(2) {
      background: transparent;
    }
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
  }

  .vote-counter {
    display: flex;
    flex-flow: row nowrap;
    padding: 2rem;
    gap: 2rem;
  }

  .votes {
    font-size: 3rem;
  }

  .vote {
    font-size: 5rem;
    opacity: 1;
    transition: opacity 0.2s;
  }

  .vote :global(path) {
    stroke: yellow !important;
    stroke-width: 10px !important;
    stroke-opacity: 1 !important;
  }

  .vote-button {
    font-size: 3rem;
  }

  button[disabled] {
    color: #888 !important;
  }

  .pane-1 :global(.vote-button) {
    color: black;
    background-color: #0f0;
  }

  .pane-1 :global(.vote) {
    color: #0f0;
  }

  .pane-2 :global(.vote-button) {
    color: black;
    background-color: #f00;
  }

  .pane-2 :global(.vote) {
    color: #f00;
  }

  .vote.inactive {
    opacity: 0.2;
  }

  .disabled {
    filter: grayscale(2);
  }
</style>
