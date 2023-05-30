<script lang="ts">
  import bodymovin from "lottie-web"
  import { createEventDispatcher, onMount, onDestroy, getContext } from "svelte"
  import { range } from "../../utils/maths"
  import { tweened } from "svelte/motion"

  export let src: string
  export let mouseToggle: boolean = true
  export let autoplay = false
  export let loop = true
  export let speed = 0.1

  const dispatch = createEventDispatcher()
  const id = getContext("id")
  const body = getContext("body")
  const tweenedHealth = tweened($body.health)

  let container: HTMLElement
  let animation: any
  let length = 24
  let timeout
  let hit = false

  const init = () => {
    animation = null
    animation = bodymovin.loadAnimation({
      container,
      // renderer: 'svg',
      loop: false,
      autoplay: false,
      path: src,
    })

    dispatch("load")
  }

  const cleanup = () => {
    if (animation) {
      animation.destroy()
    }
  }

  const setHit = () => {
    clearTimeout(timeout)
    hit = true
    timeout = setTimeout(() => {
      hit = false
    }, 400)
  }

  const setHealth = health => {
    setHit()
    const frame = range(0, 100, length, 0, health)
    animation?.goToAndStop(frame, true)
    $tweenedHealth = health
  }

  $: {
    setHealth($body.health)
  }

  onMount(() => {
    init()

    setHealth($body.health)
  })
  onDestroy(cleanup)
</script>

<svelte:body />

<svelte:head>
  <link
    rel="preload"
    href={src}
    as="fetch"
    type="application/json"
    crossorigin="anonymous"
  />
</svelte:head>

<div
  class="skeleton skeleton-{id}"
  style:left={id === 1 ? "20px" : "auto"}
  style:right={id === 2 ? "20px" : "auto"}
  style:transform={id === 2 ? "scale(-1,1)" : ""}
>
  <div class:hit bind:this={container} />
  <img class="bg" src="/dog-bg.svg" />
</div>
<small
  class="hp hp-{id}"
  style:left={id === 1 ? "20px" : "auto"}
  style:right={id === 2 ? "20px" : "auto"}
>
  HP: {$tweenedHealth.toFixed(0)}
</small>

<style>
  .hp {
    position: fixed;
    font-size: 20px !important;
    opacity: 0.7;
    top: 22vw;
  }

  .hp-1 {
    color: var(--player1);
  }

  .hp-2 {
    color: var(--player2);
  }
  .skeleton {
    position: fixed;
    width: 20vw;
    z-index: 999;
    pointer-events: none;
  }

  .bg {
    position: absolute;
    inset: 0;
    z-index: -1;
    transform: scale(0.91) translate(-5px, 0);
    opacity: 0.7;
  }

  .skeleton-1 :global(path) {
    fill: var(--player1) !important;
    fill-opacity: 0.7;
  }
</style>
