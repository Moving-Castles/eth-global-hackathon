<script lang="ts">
  // import { setContext } from "svelte"
  import {
    entities,
    matchSingleton,
    playerAddress,
    bodyOneCores,
    bodyTwoCores,
    playerJoinedBody,
    matchActive,
    matchOver,
    bodyOne,
    bodyTwo,
  } from "../../modules/state"
  import { setContext } from "svelte"
  import { derived } from "svelte/store"
  import { blockNumber } from "../../modules/network"
  import { join } from "../../modules/action"
  import { playSound } from "../../modules/sound"

  // import HealthSkeleton from "./HealthSkeleton.svelte"
  import HealthBar from "./HealthBar.svelte"
  import Body from "../../components/Bodies/Body.svelte"
  import Votes from "../../components/Void/Votes.svelte"
  import Ellipse from "../../components/Ellipse/Ellipse.svelte"
  import PlayerItem from "../../components/Void/PlayerItem.svelte"

  export let id: 1 | 2
  let hit = false
  let timeout
  let joinInProgress = false

  const body: Derived<BodyType[]> = derived(
    entities,
    $ents => $ents[id === 1 ? "0x01" : "0x02"]
  )
  const cores: Derived<CoreType[]> = derived(
    [bodyOneCores, bodyTwoCores],
    ([$b1c, $b2c]) => (id === 1 ? $b1c : $b2c)
  )
  const cooldown: Derived<Number> = derived(
    [blockNumber, body],
    ([$r, $b]) => Number($b.readyBlock) - Number($r)
  )

  $: isPlayerBody = $cores.map(([key]) => key).includes($playerAddress)

  // LOCAL CONTEXT
  setContext("id", id)
  setContext("body", body)
  setContext("isPlayerBody", isPlayerBody)
  setContext("cooldown", cooldown)
  setContext("cores", cores)

  function sendJoin() {
    if (joinInProgress) return
    joinInProgress = true
    playSound("tekken", "click")
    join(id)
  }

  // !!! HACK
  $: if ($matchActive) {
    joinInProgress = false
  }
</script>

<!-- svelte-ignore a11y-click-events-have-key-events -->
<div
  class="pane pane-{id}"
  class:active={$matchActive}
  class:lobby={!$matchActive}
  class:joined={$playerJoinedBody}
  class:opponent={!isPlayerBody}
  class:mine={isPlayerBody}
>
  {#if !$matchActive}
    <div class="player-list">
      <div class="spot-counter">
        {$matchSingleton?.coresPerBody - $cores.length} spots left
      </div>
      {#each $cores as [_, core] (core)}
        <PlayerItem {core} />
      {/each}
    </div>
  {/if}

  <div class="body-container">
    <Body
      mine={isPlayerBody}
      ready={$cores.length === ($matchSingleton?.coresPerBody || 1)}
      id={id === 1 ? "BODY_ONE" : "BODY_TWO"}
    />
  </div>
  <div>
    {#if $matchActive && !$matchOver}
      <HealthBar />
      <!-- <HealthSkeleton src="/SKELETON.json" /> -->
      <div class="names">
        {#each $cores as [_, core] (core)}
          {core.name}
        {/each}
      </div>
      {#if isPlayerBody}
        <Votes />
      {/if}
    {/if}
  </div>

  {#if !$playerJoinedBody}
    <div class="statistics">
      {#if $cores.length < $matchSingleton?.coresPerBody}
        <div class="statistics-content">
          {#if !$playerJoinedBody && $cores.length < $matchSingleton?.coresPerBody}
            <button class="statistics-button pane-special" on:click={sendJoin}>
              {#if joinInProgress}
                <Ellipse />
              {:else}
                JOIN
              {/if}
            </button>
          {/if}
        </div>
      {:else}
        <div class="statistics-content statistics-content-main">READY</div>
      {/if}
    </div>
  {/if}

  {#if $matchOver}
    <div class="results">
      <h1>
        {#if $body.health > 0}
          WINNER
        {:else if $bodyOne.health === 0 && $bodyTwo.health === 0}
          TIED
        {:else if $body.health === 0}
          LOSER
        {/if}
      </h1>
    </div>
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
    /* transition: all 1s ease; */
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
    width: 180px;
  }

  .name {
    position: fixed;
    top: 80px;
  }

  .names {
    position: absolute;
    bottom: 20px;
    left: 50%;
    transform: translate(-50%, 0);
  }

  .spot-counter {
    background: black;
    color: white;
    padding: 10px;
    border-radius: 5px;
  }
</style>
