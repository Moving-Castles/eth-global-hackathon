<script lang="ts">
  import { ActionType } from "../../modules/entities"
  import ActionTypeButton from "../../components/ActionTypeButton/ActionTypeButton.svelte"
  import { getContext, onMount } from "svelte"
  import { playerCore } from "../../modules/player"
  
  export let id: number
  export let playerVote: number
  export let cooldownTime: number
  
  const body = getContext('body')
  const cores = getContext('cores')

  const actionTypeStrings = [...Array(Object.keys(ActionType).length / 2).keys()]

  onMount(() => {
    console.log('on mount')
  })
</script>

{#key $body.roundIndex}
<div
  class="votes"
  style:right={id === 1 ? 'auto' : '40px'}
  style:left={id === 2 ? 'auto' : '40px'}
>
  {#each Object.keys(ActionType).filter(key => isNaN(key) && key !== 'NONE') as type, i (type)}
    <ActionTypeButton actionType={type} />
  {/each}
</div>
{/key}

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
    opacity: 0.2;
  }
</style>
