<script lang="ts">
  import { bodiesReady, matchActive } from "../../modules/state"
  import { getContext } from "svelte"
  export let sources: string | any[] = []
  export let id: "BODY_ONE" | "BODY_TWO"
  import { mask } from "../../utils/transitions"
  import { fade } from "svelte/transition"
  import { range } from "../../utils/maths"
  import { elasticOut, cubicOut, quartOut } from "svelte/easing"

  let navigable = !$bodiesReady
  let index = 0

  const next = () => {
    if (navigable) index = (index + 1) % sources.length
  }

  const prev = () => {
    if (navigable) index = (index - 1 + sources.length) % sources.length
  }

  const cooldown = getContext("cooldown")

  function slap(node, { delay = 0, duration = 1500 }) {
    const o = +getComputedStyle(node).opacity
    const tt = getComputedStyle(node).transform

    return {
      delay,
      duration,
      css: t => {
        const eased = elasticOut(t)
        const scale = range(0, 1, 3, 1, quartOut(t))
        return `
          transform: ${tt} scale(${scale}) rotate(${eased * 1080}deg);
        `
      },
    }
  }

  $: if ($bodiesReady) {
    index = 0
    navigable = false
  }
</script>

<div class="slider cooldown-{$cooldown}">
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
          {#if i !== 0}
            {#key i}
              <div out:fade in:slap class="locked">
                <div style:transform="rotate({20 - 40 * Math.random()}deg)">
                  LOCKED
                </div>
              </div>
            {/key}
          {/if}
          <p class:first={i === 0} class="name pane-special">{name}</p>
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
            <path d="M63 37L-3.4258e-06 73.3731L-2.45961e-07 0.626931L63 37Z" />
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
    transition: filter 1s linear;
  }

  .cooldown-5 {
    filter: contrast(5) grayscale(1);
  }
  .cooldown-4 {
    filter: contrast(4) grayscale(0.8);
  }
  .cooldown-3 {
    filter: contrast(3) grayscale(0.6);
  }
  .cooldown-2 {
    filter: contrast(2) grayscale(0.4);
  }
  .cooldown-1 {
    filter: contrast(1) grayscale(0.2);
  }

  .slide {
    position: absolute;
    inset: 0;
    opacity: 0;
    width: 100%;
    display: block;
  }

  .locked {
    position: absolute;
    top: 50%;
    left: 50%;
    font-family: var(--font-family-special);
    font-size: 3rem;
    z-index: 999;
    color: red;
    transform: translate(-50%, -50%) translateY(20px);
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
    text-align: center;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    padding: 10px 20px;
    background: white;
    color: black;
    line-height: 20px;
  }

  .name:not(.first) {
    background: black;
    color: rgba(255, 255, 255, 0.7);
  }

  .visible {
    opacity: 100;
  }

  .nav-next {
    position: absolute;
    z-index: 99;
  }

  .prevButton {
    fill: white;
    position: absolute;
    top: 50%;
    transform: scale(-0.5, 0.5);
    left: 0;
    cursor: pointer;
    z-index: 99;
  }

  .nextButton {
    fill: white;
    position: absolute;
    top: 50%;
    transform: scale(0.5);
    right: 0;
    cursor: pointer;
    z-index: 99;
  }

  .nextButton:hover :global(path),
  .prevButton:hover :global(path) {
    fill: black !important;
  }
</style>
