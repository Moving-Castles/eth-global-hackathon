<script lang="ts">
  import {
    bodies,
    coresInBodies,
    playerAction,
    playerAddress,
  } from "../../modules/state"
  import { ActionType } from "../../modules/action"
  import ActionIcon from "./ActionIcon.svelte"
  export let id: 1 | 2
</script>

<div class="round-counter">Round: {$bodies[id].roundIndex}</div>
<div class="submitted-votes">
  {#each $coresInBodies[id] as core}
    <div class="vote">
      {#if core[0] === $playerAddress}
        <!-- Local player -->
        {#if $playerAction !== ActionType.NONE}
          <ActionIcon actionType={$playerAction} />
        {:else if core[1].roundIndex > $bodies[id].roundIndex}
          <ActionIcon actionType={core[1].vote} />
        {/if}
      {:else}
        <!-- Other player -->
        {#if core[1].roundIndex > $bodies[id].roundIndex}
          <ActionIcon actionType={core[1].vote} />
        {/if}
      {/if}
    </div>
  {/each}
</div>

<style lang="scss">
  .round-counter {
    text-align: center;
    margin-bottom: 10px;
  }

  .submitted-votes {
    display: flex;
    justify-content: center;
    .vote {
      width: 50px;
      height: 50px;
      background: rgb(211, 211, 211, 0.5);
      border: 2px solid white;
      font-size: 8px;
      display: flex;
      justify-content: center;
      align-items: center;
      margin-right: 20px;
    }
  }
</style>
