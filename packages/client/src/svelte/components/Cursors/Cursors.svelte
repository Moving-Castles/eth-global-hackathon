<script lang="ts">
  import { cores, bodyOneCores, bodyTwoCores } from "../../modules/state"
  import { sendPosition, cursors } from "../../modules/signal"
  import throttle from "just-throttle"
  import Icon from "@iconify/svelte"

  $: colors = Object.fromEntries([
    ...$bodyOneCores.map(([k, _]) => [k, "var(--player1)"]),
    ...$bodyTwoCores.map(([k, _]) => [k, "var(--player2)"]),
  ])
</script>

<svelte:window on:mousemove={throttle(sendPosition, 160)} />

{#each Object.entries($cursors) as [key, value]}
  <div
    class="cursor"
    id={key}
    style={`transform: translateX(${value.x}px) translateY(${value.y}px);`}
    style:color={colors[key]}
  >
    <div class="cursor-icon">
      <Icon icon="game-icons:fairy-wand" />
    </div>
    <div class="cursor-text">
      {$cores[key]?.name}
    </div>
  </div>
{/each}

<style>
  .cursor {
    width: 40px;
    height: 40px;
    top: 0;
    left: 0;
    position: fixed;
    z-index: 10000;
    pointer-events: none;
    transition: transform 0.2s ease-in-out;
    text-align: center;
    display: flex;
    justify-content: center;
    align-items: center;
    flex-wrap: wrap;
    color: white;
  }

  .cursor-icon {
    font-size: 3em;
    opacity: 0.5;
  }

  .cursor-text {
    font-size: 10px;
  }
</style>
