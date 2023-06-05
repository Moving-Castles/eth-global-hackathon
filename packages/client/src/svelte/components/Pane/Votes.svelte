<script lang="ts">
  import { getContext } from "svelte"
  import { ActionType } from "../../modules/action"
  import ActionTypeButton from "../ActionTypeButton/ActionTypeButton.svelte"

  const id = getContext("id")
  const cooldown = getContext("cooldown")
</script>

<div
  class="votes"
  class:disabled={$cooldown > -1}
  style:right={id === 1 ? "auto" : "40px"}
  style:left={id === 2 ? "auto" : "40px"}
>
  {#each Object.keys(ActionType).filter(key => isNaN(key) && key !== "NONE") as type, i (type)}
    <ActionTypeButton actionType={type} />
  {/each}
</div>

<style>
  .votes {
    right: 40px;
    height: 50vh;
    bottom: 40px;
    display: flex;
    flex-flow: column nowrap;
    justify-content: center;
    gap: 20px;
    position: fixed;
    transition: opacity 0.1s ease;
  }
</style>
