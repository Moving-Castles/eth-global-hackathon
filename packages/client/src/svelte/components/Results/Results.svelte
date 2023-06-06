<script lang="ts">
  import { matchWinner, BODY_ONE } from "../../modules/state"
  import { lore } from "../../modules/content/lore"

  let winnerName = ""

  $: if ($matchWinner) {
    winnerName =
      $matchWinner === BODY_ONE
        ? lore.governance_models_P1[0]
        : lore.governance_models_P2[0]
  } else {
    winnerName = ""
  }
</script>

<div class="results">
  {#if $matchWinner}
    {winnerName} wins!
  {:else}
    It's a tie!
  {/if}
</div>

<style lang="scss">
  .results {
    position: fixed;
    top: 20%;
    left: 50%;
    transform: translate(-50%, -50%);
    background: purple;
    padding: 20px;
  }
</style>
