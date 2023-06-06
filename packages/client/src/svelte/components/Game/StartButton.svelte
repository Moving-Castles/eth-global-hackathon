<script lang="ts">
  import { playSound } from "../../modules/sound"
  import { start } from "../../modules/action"
  import Ellipse from "../Ellipse/Ellipse.svelte"

  let startInProgess = false

  function sendStart() {
    if (startInProgess) return
    startInProgess = true
    playSound("tekken", "click")
    start()
  }
</script>

<button class="button start-button" on:click={sendStart}>
  {#if startInProgess}
    <Ellipse />
  {:else}
    START
  {/if}
</button>

<style lang="scss">
  .start-button {
    font-size: 48px;
    border: 0;
    padding: 20px 40px;
    width: 300px;
  }
</style>
