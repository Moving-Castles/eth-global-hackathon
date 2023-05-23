<script lang="ts">
  export let sources = []
  export let ready
  export let target
  export let id: "BODY_ONE" | "BODY_TWO"
  import { mask } from "../../transitions"

  let navigable = true
  let index = 0

  const next = () => {
    if (navigable) index = (index + 1) % sources.length
  }

  $: if (ready) {
    index = 0
    navigable = false
  }
</script>

<div class="slider">
  <!-- <button class="nav-next" on:click={next}>next</button> -->
  {#each sources as { name, src }, i (src)}
    {#key index}
      <!-- in:fly={{ x: id === "BODY_ONE" ? -400 : 400 }} -->
      <div
        in:mask={{
          feather: 10,
          duration: 400,
          type: "leftToRight",
        }}
        out:mask={{
          feather: 10,
          duration: 400,
          type: "rightToLeft",
        }}
        class="slide"
        class:visible={i === index}
        on:click={next}
      >
        <img {src} />
        <p class="name">{name}</p>
      </div>
    {/key}
  {/each}
</div>

<style>
  .slider {
    position: relative;
    aspect-ratio: 1;
    width: 100%;
  }

  .slide {
    position: absolute;
    inset: 0;
    opacity: 0;
    width: 100%;
    display: block;
  }

  img {
    width: 100%;
    aspect-ratio: 1;
    object-fit: contain;
  }

  .name {
    position: absolute;
    width: 400px;
    text-align: center;
    bottom: 0;
    left: 50%;
    transform: translate(-50%, 200%);
  }

  .visible {
    opacity: 100;
  }

  .nav-next {
    position: absolute;
    z-index: 99;
  }
</style>
