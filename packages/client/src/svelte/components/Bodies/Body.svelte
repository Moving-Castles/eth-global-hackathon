<script lang="ts">
  export let id
  export let joined: boolean
  export let ready: boolean
  export let active: boolean
  export let mine: boolean

  $: sources = {
    BODY_ONE: active ? '/bodies/active-1.gif' : '/bodies/1.png',
    BODY_TWO: active ? '/bodies/active-2.gif' : '/bodies/2.png',
  }

</script>

<img class="body" class:joined={joined || ready} class:other={!active && !mine && joined} src={sources[id]} >

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

  .body.other {
    filter: grayscale(1);
    opacity: 0.8;
  }
</style>