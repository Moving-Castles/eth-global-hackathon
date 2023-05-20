<script lang="ts">
  import { createEventDispatcher } from "svelte"
  import { loadingMessage, ready } from "../../modules/network"
  import { playerCore } from "../../modules/player"
  import { onMount } from "svelte"

  const dispatch = createEventDispatcher()

  const next = () => dispatch("next")

  $: if ($playerCore && $ready) next()
</script>

<div class="">
  <div class="loading" class:story={$ready} on:click={next}>
    <div class="loading-message">{$loadingMessage}</div>
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
      font-size: 3rem;
      color: red;
    }
  }
</style>
