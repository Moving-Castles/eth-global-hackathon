<script lang="ts">
  import { onMount } from "svelte"
  import { tweened } from "svelte/motion"
  import { entities, bodies } from "../../modules/state"

  export let id: 1 | 2

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
    $health = $bodies[id].health
    entities.subscribe(newEntities => {
      const entity = newEntities[id === 1 ? "0x01" : "0x02"]
      if (entity) {
        if (entity.health !== previousHealth) {
          setHit()
          health.set(entity.health)
          previousHealth = entity.health
        }
      }
    })
  })
</script>

<div class:hit class="health player-{id} bar">
  <div
    style:right={id === 2 ? 0 : "auto"}
    style:left={id === 1 ? 0 : "auto"}
    style:height="{$health.toFixed(0)}%"
    style:background-color={id === 1 ? "var(--player1)" : "var(--player2)"}
    class="bar-inner"
  />

  <div class="bar-background" />
</div>

<style>
  .health {
    position: fixed;
    top: 50px;
  }

  .player-1 {
    left: 20px;
  }

  .player-2 {
    right: 20px;
  }

  .bar {
    width: 60px;
    height: 75vh;
    background-position: top center;
    /* filter: invert(1); */
  }

  .bar-background {
    position: absolute;
    top: 0;
    left: 0;
    bottom: 0;
    right: 0;
    width: 100%;
    height: 100%;
    background: rgba(211, 211, 211, 0.3);
    z-index: 1;
  }

  @keyframes move {
    from {
      background-position: 30% 0;
    }
    to {
      background-position: 70% 0;
    }
  }

  .bar-inner {
    position: absolute;
    bottom: 0;
    width: 100%;
    background: red;
    z-index: 2;
  }

  .player-1 .bar-inner,
  .player-1 .bar-background {
    clip-path: polygon(0% 0%, 100% 0%, calc(100% - 20px) 100%, 0% 100%);
  }

  .player-2 .bar-inner,
  .player-2 .bar-background {
    clip-path: polygon(0 0, 100% 0%, 100% 100%, 20px 100%);
  }
</style>
