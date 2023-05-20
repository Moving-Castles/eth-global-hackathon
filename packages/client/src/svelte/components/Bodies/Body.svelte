<script lang="ts">
  export let id
  export let joined: boolean
  export let ready: boolean

  console.log(joined)
</script>

<!-- Body 1 -->
{#if id === "BODY_ONE"}
  <img class="body" class:joined={joined || ready} src="/bodies/1.png" >
{/if}

<!-- Body 2 -->
{#if id === "BODY_TWO"}
  <img class="body" class:joined={joined || ready} src="/bodies/2.png" >
{/if}

<style>
  .body {
    width: 100%;
    transition: opacity 300ms ease;
  }
  .body:not(.joined) {
    opacity: 0.5;
  }
  .body:hover {
    opacity: 1;
  }
</style>