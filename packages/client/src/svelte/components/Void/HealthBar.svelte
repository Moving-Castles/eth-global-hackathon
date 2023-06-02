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
    style:background-color={id === 1 ? "var(--player1)" : "var(--player2)"}
    class="bar-inner"
  />

  <div class="bar-background" />
</div>

<style>
  .health {
    position: fixed;
    margin: 2rem 0;
  }

  .player-1 {
    left: 0;
    clip-path: polygon(0% 0%, 100% 0%, calc(100% - 20px) 100%, 0% 100%);
  }

  .player-2 {
    right: 0;
    clip-path: polygon(0 0, 100% 0%, 100% 100%, 20px 100%);
  }

  .bar {
    width: 40vw;
    height: 60px;
    background-position: top center;
    /* filter: invert(1); */
  }

  .bar-background {
    position: absolute;
    top: 0;
    left: 0;
    bottom: 0;
    right: 0;
    background-image: url("/stage.png");
    width: 100%;
    height: 100%;
    filter: saturate(0);
    mix-blend-mode: lighten;
    z-index: 1;
    animation: move 30s infinite linear;
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
    height: 100%;
    background-image: url("/stage.png");
    background-position: top center;
    filter: saturate(2);
    mix-blend-mode: overlay;
    z-index: 2;
  }

  .player-1 .bar-inner {
    /* clip-path: polygon(0% 0%, 100% 0%, calc(100% - 20px) 100%, 0% 100%); */
  }

  .player-2 .bar-inner {
    /* clip-path: polygon(0 0, 100% 0%, 100% 100%, 20px 100%); */
  }
</style>
