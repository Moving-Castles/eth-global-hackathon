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
          <span class="pending">
            <ActionIcon actionType={$playerAction} />
          </span>
        {:else if core[1].roundIndex > $bodies[id].roundIndex}
          <span class="confirmed">
            <ActionIcon actionType={core[1].vote} />
          </span>
        {/if}
      {:else}
        <!-- Other player -->
        {#if core[1].roundIndex > $bodies[id].roundIndex}
          <span class="confirmed">
            <ActionIcon actionType={core[1].vote} />
          </span>
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
      width: 80px;
      height: 80px;
      background: rgb(211, 211, 211, 0.5);
      border: 2px solid white;
      font-size: 8px;
      display: flex;
      justify-content: center;
      align-items: center;
      margin-right: 20px;

      .pending {
        opacity: 0.5;
        text-align: center;
      }

      .confirmed {
        opacity: 1;
        text-align: center;
      }
    }
  }
</style>
