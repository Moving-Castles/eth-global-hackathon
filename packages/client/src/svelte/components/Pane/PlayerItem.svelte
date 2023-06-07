<script lang="ts">
  import { matchActive } from "../../modules/state"
  import type { Core } from "../../modules/state/types"
  import { typewriter } from "../../utils/transitions"
  export let core: Core
</script>

<div class="core" class:match={$matchActive} in:typewriter={{ speed: 100 }}>
  {core.name}
</div>

<style lang="scss">
  .core {
    font-family: var(--font-family-special);
    font-size: 32px;
    color: black;
    text-align: center;
    line-height: 1.6em;

    &.match {
      font-size: 18px;
    }
  }
</style>
