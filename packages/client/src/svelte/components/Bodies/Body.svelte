<script lang="ts">
  import BodySlider from "./BodySlider.svelte"
  import { lore } from "../../modules/lore"
  export let id: string
  export let joined: boolean
  export let ready: boolean
  export let active: boolean
  export let mine: boolean
  export let actionType = "NONE"

  let modelSources = []

  // $: sources = {
  //   BODY_ONE: active ? "/bodies/active-1.gif" : "/bodies/1.png",
  //   BODY_TWO: active ? "/bodies/active-2.gif" : "/bodies/2.png",
  // }

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
      console.log(i)
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

    console.log(modelSources)
  }
</script>

<BodySlider {id} sources={modelSources} {ready} />

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
