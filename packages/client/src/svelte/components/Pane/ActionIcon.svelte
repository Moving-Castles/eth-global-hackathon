<script lang="ts">
  //   import { scale } from "svelte/transition"
  //   import { quadOut } from "svelte/easing"
  import { ActionType } from "../../modules/action"
  export let actionType: ActionType
  let actionTypeString = ""
  $: actionTypeString = ActionType[actionType]
</script>

<!-- in:scale={{ duration: 100, easing: quadOut }} -->
<img
  class="icon {actionTypeString}"
  src="/icons/{actionTypeString}.png"
  alt={actionTypeString}
/>

<style lang="scss">
  .icon {
    width: 60%;
    height: 60%;
  }
</style>
