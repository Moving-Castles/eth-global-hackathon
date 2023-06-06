<script lang="ts">
  // import {
  //   entities,
  //   bodies,
  //   coresInBodies,
  //   cooldownOnBodies,
  //   matchOver,
  // } from "../../modules/state"
  // import { ActionType } from "../../modules/action"
  // import { delayedWritable } from "../../modules/ui/stores"
  import { lore } from "../../modules/content/lore"
  import { playSound } from "../../modules/sound"

  export let id: 1 | 2
  let src = `/states/${id}/idle.gif`
  const modelsKey = {
    1: "governance_models_P1",
    2: "governance_models_P2",
  }
  let name: string = lore[modelsKey[id]][0]

  function click() {
    playSound("misc", "friendly")
  }

  // let endActionType = "NONE"

  // let modelSources: any[] = []

  // $: states = {
  //   NONE: `/states/${id}/idle.gif`,
  //   HEAL: `/states/${id}/heal.gif`,
  //   ATTACK_ONE: `/states/${id}/hit.gif`,
  //   ATTACK_TWO: `/states/${id}/hit.gif`,
  //   ATTACK_THREE: `/states/${id}/hit.gif`,
  //   TAUNT: `/states/${id}/taunt.gif`,
  //   // NOT IN
  //   WIN: `/states/${id}/win.gif`,
  //   DIE: `/states/${id}/die.gif`,
  // }

  // $: stateSrc = states[$matchOver ? endActionType : $delayedActionType]

  // $: {
  //   let i = 1
  //   modelSources = lore[modelsKey].map(name => {
  //     let result
  //     if (i === 1) {
  //       result = {
  //         src: stateSrc,
  //         name,
  //       }
  //     } else {
  //       result = {
  //         src: `/_bodiess/${id}/000${i}.png`,
  //         name,
  //       }
  //     }
  //     i++

  //     return result
  //   })
  // }

  // const delayedActionType = delayedWritable("NONE", 500)

  // $: {
  //   const body = $entities[id === "BODY_ONE" ? "0x01" : "0x02"]
  //   const opponentBody = $entities[id === "BODY_ONE" ? "0x02" : "0x01"]

  //   if (body?.health === 0 || opponentBody?.health === 0) {
  //     if (body.health === 0) {
  //       // You lose some
  //       endActionType = "DIE"
  //     } else if (opponentBody.health === 0) {
  //       // You win some
  //       endActionType = "WIN"
  //     }
  //   }
  // }

  // $: allVotesAreIn = $coresInBodies[id]
  //   .map(([_, core]) => core.roundIndex)
  //   .every(roundIndex => roundIndex === $bodies[id].roundIndex)

  // $: if (allVotesAreIn && $cooldownOnBodies[id] === 5) {
  //   console.log("NOW")
  //   $delayedActionType = ActionType[$bodies[id].lastAction]
  // }
</script>

<!-- svelte-ignore a11y-click-events-have-key-events -->
<div class="body" on:click={click}>
  <p class="name pane-special">{name}</p>
  <div class="inner">
    <img
      {src}
      style:transform={id === 1 ? "scale(1)" : "scale(-1, 1)"}
      alt="img"
    />
  </div>
</div>

<style lang="scss">
  .body {
    position: relative;
    aspect-ratio: 1;
    width: 100%;
    transition: filter 1s linear;
    cursor: pointer;

    .name {
      position: absolute;
      text-align: center;
      top: 50%;
      left: 50%;
      transform: translate(-50%, -50%);
      padding: 10px 20px;
      background: white;
      color: black;
      line-height: 20px;
      z-index: 1000;
    }

    .inner {
      position: absolute;
      inset: 0;
      opacity: 100;
      width: 100%;
      display: block;
      width: 100%;
      aspect-ratio: 1;
      object-fit: contain;
      img {
        height: 100%;
        width: 100%;
      }
    }
  }
</style>
