<script lang="ts">
  import { ActionType } from "../../modules/entities"
  import ActionTypeButton from "../../components/ActionTypeButton/ActionTypeButton.svelte"
  import { getContext } from "svelte"
  
  export let id: number
  export let coreVote: number
  
  const bodyOneCores = getContext("bodyOneCores")
  const bodyTwoCores = getContext("bodyTwoCores")

  let voteProgress = []

  $: bodyCores = id === 1 ? bodyOneCores : bodyTwoCores

  $: {
    voteProgress = [...Array(Object.keys(ActionType).length / 2).keys()].map((actionTypeIndex) => {
      const count = $bodyCores.filter(([k, core]) => core.vote === actionTypeIndex)?.length || 0

      const progress = count / $bodyCores.length

      return progress
    })
  }

  $: console.log($bodyCores.map(core => core))
</script>

<div
  class="votes"
  class:disabled={!isNaN(coreVote) && coreVote !== 0}
  style:right={id === 1 ? 'auto' : '40px'}
  style:left={id === 2 ? 'auto' : '40px'}
>
  {#each Object.keys(ActionType).filter(key => isNaN(key) && key !== 'NONE') as type, i (type)}
    <ActionTypeButton
      disabled={!isNaN(coreVote) && coreVote !== 0}
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
  }
  
  .votes-grid {
    position: absolute;
    height: 100%;
    display: flex;
    flex-flow: column nowrap;
    justify-content: center;
    gap: 20px;
  }
</style>
