<script lang="ts">
  import { createEventDispatcher } from "svelte"
  import { loadingMessage, ready } from "../../modules/network"
  import { playerCore } from "../../modules/gameState"

  const dispatch = createEventDispatcher()

  const next = () => dispatch("next")

  $: if ($playerCore && $ready) next()
</script>

<div>
  <!-- svelte-ignore a11y-click-events-have-key-events -->
  <div class="loading" class:story={$ready} on:click={next}>
    <div class="loading-message" class:story-inner={$ready}>
      {$loadingMessage}
    </div>
  </div>
</div>

<style lang="scss">
  .loading {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: #ffffff;
    color: black;
    display: flex;
    justify-content: center;
    align-items: center;
    padding: 3rem;
    font-size: 12px;

    &.story {
      background: #000;
      font-size: 4rem;
      line-height: 4rem;
      color: red;
      background: black;
    }

    .story-inner {
      background: #000;
      font-size: 4rem;
      line-height: 4.5rem;
      color: red;
      max-width: 80%;
      margin-left: auto;
      margin-right: auto;
      font-family: var(--font-family-special);
    }
  }
</style>
