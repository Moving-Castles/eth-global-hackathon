<script lang="ts">
  import { join } from "../../modules/action"
  import { playSound } from "../../modules/sound"
  import Ellipse from "../../components/Ellipse/Ellipse.svelte"

  export let id: 1 | 2

  let joinInProgress = false

  function sendJoin() {
    if (joinInProgress) return
    joinInProgress = true
    playSound("tekken", "click")
    join(id)
  }
</script>

<button class="button join-button" on:click={sendJoin}>
  {#if joinInProgress}
    <Ellipse />
  {:else}
    JOIN
  {/if}
</button>

<style lang="scss">
  .join-button {
    color: white;
    background: black;
    font-size: 3rem;
    width: 180px;
  }
</style>
