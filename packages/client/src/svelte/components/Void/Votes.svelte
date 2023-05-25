<script lang="ts">
  import { ActionType } from "../../modules/gameState"
  import ActionTypeButton from "../../components/ActionTypeButton/ActionTypeButton.svelte"
  import { getContext } from "svelte"
  
  export let id: number
  export let playerVote: number
  export let cooldownTime: number
  
  const bodyOneCores = getContext("bodyOneCores")
  const bodyTwoCores = getContext("bodyTwoCores")

  const actionTypeStrings = [...Array(Object.keys(ActionType).length / 2).keys()]
  let voteProgress = actionTypeStrings.map(_ => 0)

  $: bodyCores = id === 1 ? bodyOneCores : bodyTwoCores
  $: disabled = !isNaN(playerVote) && playerVote !== 0 || cooldownTime > -1

  $: {
    voteProgress = actionTypeStrings.map((actionTypeIndex) => {
      const count = $bodyCores.filter(([_, core]) => core.vote === actionTypeIndex)?.length || 0
      const progress = count / $bodyCores.length

      return progress
    })
  }
</script>

<div
  class="votes"
  class:disabled
  style:right={id === 1 ? 'auto' : '40px'}
  style:left={id === 2 ? 'auto' : '40px'}
>
  {#each Object.keys(ActionType).filter(key => isNaN(key) && key !== 'NONE') as type, i (type)}
    <ActionTypeButton
      {id}
      {disabled}
      {playerVote}
      actionType={type}
      progress={voteProgress[i + 1]}
    />
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
    opacity: 0.2;
  }
</style>
