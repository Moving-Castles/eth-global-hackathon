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

  function joinBody(i: 1 | 2) {
    if (!joined) $network.worldSend(WorldFunctions.Join, [i])
  }

  onMount(() => {
    playerVote = $entities[$playerAddress]?.vote
  })
</script>

<div class="pane" class:active on:click={() => joinBody(1)}>
  <div class="body-container">
    <Body
      {joined}
      {active}
      ready={$bodyCores.length === $matchSingleton?.coresPerBody}
      id={id === 1 ? "BODY_ONE" : "BODY_TWO"}
    />
  </div>
  <div>
    <!-- <button on:click={() => joinBody(1) }>BODY 1</button> -->
    {#if active}
      <div>
        H: {$entities["0x01"]?.health}
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
