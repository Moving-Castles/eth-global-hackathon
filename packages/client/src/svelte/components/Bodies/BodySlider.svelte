<script lang="ts">
  import { bodiesReady, matchActive } from "../../modules/state"
  export let sources: string | any[] = []
  export let id: "BODY_ONE" | "BODY_TWO"
  import { mask } from "../../utils/transitions"

  let navigable = !$bodiesReady
  let index = 0

  const next = () => {
    if (navigable) index = (index + 1) % sources.length
  }

  const prev = () => {
    if (navigable) index = (index - 1 + sources.length) % sources.length
  }

  $: if ($bodiesReady) {
    index = 0
    navigable = false
  }
</script>

<div class="slider">
  <!-- <button class="nav-next" on:click={next}>next</button> -->
  {#each sources as { name, src }, i (src)}
    {#key index}
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
      >
        <img
          class:first={i === 0}
          {src}
          style:transform={id === "BODY_ONE" ? "scale(1)" : "scale(-1, 1)"}
          alt="img"
        />
        {#if !$matchActive}
          <p class="name">{name}</p>
          <!-- svelte-ignore a11y-click-events-have-key-events -->
          <svg
            class="prevButton"
            on:click={prev}
            width="63"
            height="74"
            viewBox="0 0 63 74"
            fill="none"
            xmlns="http://www.w3.org/2000/svg"
          >
            <path
              d="M63 37L-3.4258e-06 73.3731L-2.45961e-07 0.626931L63 37Z"
              fill="#fff"
            />
          </svg>

          <!-- svelte-ignore a11y-click-events-have-key-events -->
          <svg
            class="nextButton"
            on:click={next}
            width="63"
            height="74"
            viewBox="0 0 63 74"
            fill="none"
            xmlns="http://www.w3.org/2000/svg"
          >
            <path
              d="M63 37L-3.4258e-06 73.3731L-2.45961e-07 0.626931L63 37Z"
              fill="#fff"
            />
          </svg>
        {/if}
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

  .prevButton {
    position: absolute;
    top: 50%;
    transform: scale(-0.5, 0.5);
    left: 0;
  }

  .nextButton {
    position: absolute;
    top: 50%;
    transform: scale(0.5);
    right: 0;
  }
</style>
