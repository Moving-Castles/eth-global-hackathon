<script lang="ts">
  import { getContext } from "svelte"
  import { ActionType } from "../../modules/action"
  import ActionTypeButton from "../../components/ActionTypeButton/ActionTypeButton.svelte"

  const id = getContext("id")
  const cooldown = getContext("cooldown")

  const actionTypeStrings = [
    ...Array(Object.keys(ActionType).length / 2).keys(),
  ]
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
    width: 50vw;
    bottom: 40px;
    display: flex;
    flex-flow: row nowrap;
    justify-content: center;
    gap: 20px;
    position: fixed;
    transition: opacity 0.1s ease;
  }
</style>
