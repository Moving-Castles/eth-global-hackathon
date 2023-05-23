<script lang="ts">
  import BodySlider from "./BodySlider.svelte"
  import { lore } from "../../modules/lore"
  import { entities, ActionType } from "../../modules/entities"
  import { onMount } from "svelte"

  export let id: string
  export let joined: boolean
  export let ready: boolean
  export let active: boolean
  export let mine: boolean

  let previousActionType = "NONE"
  let actionType = "NONE"
  let modelSources = []
  let timeout

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

  $: stateSrc = states[actionType]

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

  const setState = (state, delay) => {
    clearTimeout(timeout)
    actionType = state
    timeout = setTimeout(() => {
      actionType = "NONE"
    }, delay)
  }

  $: console.log(actionType)

  onMount(() => {
    const entKey = id === 1 ? "0x01" : "0x02"
    previousActionType = $entities[entKey].lastAction
    actionType = "NONE"

    entities.subscribe(newEntities => {
      const ent = newEntities[entKey]

      if (ent) {
        if (ent.lastAction !== previousActionType) {
          // Who does the action?
          setState(ActionType[ent?.lastAction], 400)
          previousActionType = ActionType[ent?.lastAction]
        }
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
