<script lang="ts">
  import BodySlider from "./BodySlider.svelte"
  import { lore } from "../../modules/lore"
  import { entities, ActionType } from "../../modules/entities"
  import { playerAddress } from "../../modules/player"
  import { delayedWritable } from "../../modules/stores"
  import { onMount } from "svelte"

  export let id: string
  export let joined: boolean
  export let ready: boolean
  export let active: boolean
  export let mine: boolean

  let modelSources = []

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

  $: stateSrc = states[$delayedActionType]

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

  onMount(() => {
    const entKey = id === "BODY_ONE" ? "0x0000000000000000000000000000000000000000000000000000000000000001" : "0x0000000000000000000000000000000000000000000000000000000000000002"

    entities.subscribe((newEnts) => {
      const core = Object.entries(newEnts).find(([k, v]) => k === $playerAddress)
      const body = newEnts[id === 1 ? "0x01" : "0x02"]
      console.log(!!core, !!body)
      if (core[1]?.carriedBy === entKey) {
        // console.log(id, entKey)

        $delayedActionType = ActionType[body.lastAction]
      }
    })
  })


</script>

<BodySlider {id} {active} sources={modelSources} {ready} />

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
