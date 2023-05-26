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
    position: absolute;
    right: 40px;
    height: 100%;
    display: flex;
    flex-flow: column nowrap;
    justify-content: center;
    gap: 20px;
    transition: opacity 0.1s ease;
  }

  .votes-grid {
    position: absolute;
    height: 100%;
    display: flex;
    flex-flow: column nowrap;
    justify-content: center;
    gap: 20px;
  }

  .disabled {
    /* opacity: 0.2; */
  }
</style>
