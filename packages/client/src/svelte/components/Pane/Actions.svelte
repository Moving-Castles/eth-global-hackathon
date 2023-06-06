<script lang="ts">
  import { ActionType } from "../../modules/action"
  import ActionButton from "./ActionButton.svelte"
  export let id: 1 | 2
</script>

<div
  class="actions"
  style:right={id === 1 ? "auto" : "40px"}
  style:left={id === 2 ? "auto" : "40px"}
>
  {#each Object.keys(ActionType).filter(key => isNaN(Number(key)) && key !== "NONE") as actionType (actionType)}
    <ActionButton {id} {actionType} />
  {/each}
</div>

<style>
  .actions {
    right: 40px;
    width: calc(50vw - 80px);
    bottom: 40px;
    display: flex;
    flex-flow: row nowrap;
    justify-content: center;
    align-items: center;
    gap: 20px;
    position: fixed;
    transition: opacity 0.1s ease;
  }
</style>
