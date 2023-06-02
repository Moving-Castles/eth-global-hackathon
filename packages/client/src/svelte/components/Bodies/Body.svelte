<script lang="ts">
  import BodySlider from "./BodySlider.svelte"
  import { lore } from "../../modules/content/lore"
  import { ActionType } from "../../modules/action"
  import { entities, playerAddress, matchOver } from "../../modules/state"
  import { delayedWritable } from "../../modules/ui/stores"
  import { getContext, onMount } from "svelte"

  export let id: string
  export let mine: boolean

  const body = getContext("body")
  const cores = getContext("cores")
  const cooldown = getContext("cooldown")

  let endActionType = "NONE"

  let modelSources: any[] = []

  $: states = {
    NONE: `/states/${id}/idle.gif`,
    HEAL: `/states/${id}/heal.gif`,
    ATTACK_ONE: `/states/${id}/hit.gif`,
    ATTACK_TWO: `/states/${id}/hit.gif`,
    ATTACK_THREE: `/states/${id}/hit.gif`,
    TAUNT: `/states/${id}/taunt.gif`,
    // NOT IN
    WIN: `/states/${id}/win.gif`,
    DIE: `/states/${id}/die.gif`,
  }

  $: stateSrc = states[$matchOver ? endActionType : $delayedActionType]

  $: modelsKey =
    id === "BODY_ONE" ? "governance_models_P1" : "governance_models_P2"

  $: {
    let i = 1
    modelSources = lore[modelsKey].map(name => {
      let result
      if (i === 1) {
        result = {
          src: stateSrc,
          name,
        }
      } else {
        result = {
          src: `/_bodiess/${id}/000${i}.png`,
          name,
        }
      }
      i++

      return result
    })
  }

  const delayedActionType = delayedWritable("NONE", 500)

  $: {
    const body = $entities[id === "BODY_ONE" ? "0x01" : "0x02"]
    const opponentBody = $entities[id === "BODY_ONE" ? "0x02" : "0x01"]

    if (body?.health === 0 || opponentBody?.health === 0) {
      if (body.health === 0) {
        // You lose some
        endActionType = "DIE"
      } else if (opponentBody.health === 0) {
        // You win some
        endActionType = "WIN"
      }
    }
  }

  $: allVotesAreIn = $cores
    .map(([_, core]) => core.roundIndex)
    .every(roundIndex => roundIndex === $body.roundIndex)

  $: if (allVotesAreIn && $cooldown === 5) {
    console.log("NOW")
    $delayedActionType = ActionType[$body.lastAction]
  }
</script>

<BodySlider {id} sources={modelSources} />

<style>
  .body {
    width: 100%;
    transition: all 300ms ease;
  }
  .body:not(.joined) {
    opacity: 0.5;
  }
  .body:hover {
    opacity: 1;
  }

  .body.other {
    /* filter: contrast(0.1) saturate(100000) contrast(200); */
    opacity: 1;
  }

  .body.active {
    /* filter: contrast(0.1) saturate(100000) contrast(2000); */
  }
</style>
