<script lang="ts">
  import { entities } from "../../modules/state"
  import { tweened } from "svelte/motion"
  import { getContext, onMount } from "svelte"

  const id = getContext("id")
  const body = getContext("body")

  let hit = false
  let timeout: any
  let previousHealth = 0

  const health = tweened(previousHealth, {
    duration: 500,
  })

  const setHit = () => {
    clearTimeout(timeout)
    hit = true
    timeout = setTimeout(() => {
      hit = false
    }, 400)
  }

  onMount(() => {
    $health = $body.health
    entities.subscribe(newEntities => {
      const entity = newEntities[id === 1 ? "0x01" : "0x02"]

      if (entity) {
        if (entity?.health !== previousHealth) {
          setHit()
          health.set(entity?.health)
          previousHealth = entity?.health
        }
      }
    })
  })
</script>

<div class:hit class="health player-{id} bar">
  <div
    style:right={id === 2 ? 0 : "auto"}
    style:left={id === 1 ? 0 : "auto"}
    style:width="{$health.toFixed(0)}%"
    style:background-color={id === 1 ? "#0f0" : "#f00"}
    class="bar-inner"
  />
</div>

<style>
  .health {
    pointer-events: none;
    position: fixed;
    top: 0;
    background: #737373;
    margin: 2rem 1rem;
    border: 2px solid black;
  }

  .player-1 {
    left: 0;
  }

  .player-2 {
    right: 0;
  }

  .bar {
    width: 30vw;
    height: 30px;
  }

  .bar-inner {
    position: absolute;
    height: 100%;
    /* bottom: 0; */
  }
</style>
