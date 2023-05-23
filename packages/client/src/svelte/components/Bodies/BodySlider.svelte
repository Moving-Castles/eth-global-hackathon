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
        <img class:first={i === 0} {src} />
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

  img:not(.first) {
    transform: translateY(15px);
  }

  .name {
    position: absolute;
    padding: 10px 20px;
    text-align: center;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    background: white;
    color: black;
  }

  .visible {
    opacity: 100;
  }

  .nav-next {
    position: absolute;
    z-index: 99;
  }
</style>
