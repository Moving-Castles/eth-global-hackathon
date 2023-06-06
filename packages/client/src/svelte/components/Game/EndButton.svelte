<script lang="ts">
  import { playSound } from "../../modules/sound"
  import { end } from "../../modules/action"
  import Ellipse from "../Ellipse/Ellipse.svelte"

  let endInProgress = false

  function sendEnd() {
    if (endInProgress) return
    endInProgress = true
    playSound("tekken", "click")
    end()
  }
</script>

<button class="button end-button" on:click={sendEnd}>
  {#if endInProgress}
    <Ellipse />
  {:else}
    END
  {/if}
</button>

<style lang="scss">
  .end-button {
    font-size: 48px;
    border: 0;
    padding: 20px 40px;
    width: 300px;
  }
</style>
