<script lang="ts">
  import { onMount } from "svelte"
  import { setup } from "../mud/setup"
  import { createComponentSystem, createLoadingStateSystem } from "./systems"
  import { network, ready, blockNumber } from "./modules/network"
  import { entities, playerCore } from "./modules/state"
  // import { initStaticContent } from "./modules/staticContent"
  import { initActionSequencer } from "./modules/action/actionSequencer"
  // import { initActionUpdater } from "./modules/action/actionUpdater"
  import { initSignalNetwork } from "./modules/signal"

  import Loading from "./components/Loading/Loading.svelte"
  import Spawn from "./components/Spawn/Spawn.svelte"
  import Void from "./components/Void/Void.svelte"
  import Toasts from "./components/Toast/Toasts.svelte"
  import MinimalExecutor from "./components/Executor/MinimalExecutor.svelte"

  // - - - - -
  $: console.log("$entities", $entities)
  $: console.log("$network", $network)
  $: console.log($playerCore)
  // - - - - -

  let UIState = 0

  onMount(async () => {
    // App mounted. Start initializing...
    // initStaticContent()
    const mudLayer = await setup()
    network.set(mudLayer)
    initActionSequencer()
    // initActionUpdater()

    // Create systems to listen to changes to defined component
    for (const componentKey of Object.keys(mudLayer.contractComponents)) {
      createComponentSystem(componentKey)
    }

    // Listen to changes to the LoadingState component
    createLoadingStateSystem()

    // For convenience, we store the block number in a svelte store
    mudLayer.network.blockNumber$.subscribe((x: number) => blockNumber.set(x))

    // !! HACK
    setTimeout(initSignalNetwork, 3000)
  })
</script>

<div class="executor">
  <MinimalExecutor />
</div>

<main>
  {#if !$ready || UIState === 0}
    <Loading on:next={() => (UIState = 1)} />
  {:else if !$playerCore}
    <Spawn />
  {:else}
    <Void />
  {/if}
</main>

<Toasts />

<style>
  .executor {
    position: fixed;
    top: 0;
    left: 0;
    z-index: 10000;
    opacity: 0.5;
  }
</style>
