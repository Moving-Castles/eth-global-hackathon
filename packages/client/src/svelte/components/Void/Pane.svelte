<script lang="ts">
  import { getContext } from "svelte"
  import Body from "../../components/Bodies/Body.svelte"
  import {
    entities,
    cores,
    matchSingleton,
    ActionType,
  } from "../../modules/entities"
  import { playerAddress } from "../../modules/player"
  import { network } from "../../modules/network"
  import { WorldFunctions } from "../../modules/actionSequencer"
  import { onMount } from "svelte"

  export let id: number
  export let joined: boolean
  export let active: boolean

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
  // $: bodyVotes = $bodyCores.map(([_, v]) => v.vote)

  function joinBody(i: 1 | 2) {
    if (!joined) $network.worldSend(WorldFunctions.Join, [i])
  }

  onMount(() => {
    playerVote = $entities[$playerAddress]?.vote
  })
</script>

<!-- svelte-ignore a11y-click-events-have-key-events -->
<div class="pane pane-{id}" class:active on:click={() => joinBody(id)}>
  <div class="vote-counter">
    {#each $bodyCores as [k, entry]}
      {ActionType[entry.vote]}
    {/each}
  </div>

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
    <!-- <button on:click={() => joinBody(1) }>BODY 1</button> -->
    {#if active}
      <div>
        H: {$entities[id === 1 ? "0x01" : "0x02"]?.health}
      </div>
    {/if}
    {#each $bodyCores as [key, value]}
      <div class="core">
        <div class="core__name">
          {$cores[key]?.name}
          {#if key === $playerAddress}(YOU){/if}
        </div>
      </div>
    {/each}
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
    <div class="votes">
      <button disabled={playerVote !== undefined} on:click={attackOne}
        >ATTACK I</button
      >
      <button disabled={playerVote !== undefined} on:click={attackTwo}
        >ATTACK II</button
      >
      <button disabled={playerVote !== undefined} on:click={taunt}>TAUNT</button
      >
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
  }

  .body-statistics {
    position: absolute;
    bottom: 0;
  }

  .statistics {
    align-self: start;
  }
</style>
