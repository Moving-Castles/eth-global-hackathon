<script lang="ts">
  import { entities } from "../../modules/entities"
  import { tweened } from "svelte/motion"
  import { onMount } from "svelte"

  export let id: number

  let hit = false
  let timeout
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
    $health = $entities[id === 1 ? "0x01" : "0x02"]?.health
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
    style:height="{$health.toFixed(0)}%"
    style:background-color={id === 1 ? "#0f0" : "#f00"}
    class="bar-inner"
  />
</div>

<style>
  .health {
    pointer-events: none;
    position: fixed;
    top: 120px;
    background: #000;
    margin: 0 2rem;
    clip-path: polygon(20% 0%, 80% 0%, 100% 100%, 0% 100%);
    border: 5px solid yellow;
  }

  .player-1 {
    left: 0;
  }

  .player-2 {
    right: 0;
  }

  .bar {
    height: 200px;
    width: 30px;
  }

  .bar-inner {
    position: absolute;
    bottom: 0;
    width: 100%;
  }
</style>
