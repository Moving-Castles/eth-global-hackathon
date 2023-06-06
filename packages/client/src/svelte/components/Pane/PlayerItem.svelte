<script lang="ts">
  import type { Core } from "../../modules/state/types"
  import { typewriter } from "../../utils/transitions"
  export let core: Core
</script>

<div class="core" in:typewriter={{ speed: 100 }}>
  {core.name}
</div>

<style>
  .core {
    font-family: var(--font-family-special);
    font-size: 32px;
    color: black;
    text-align: center;
  }
</style>
