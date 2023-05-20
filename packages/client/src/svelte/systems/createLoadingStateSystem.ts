import { get } from "svelte/store";
import { network, ready, loadingMessage } from "../modules/network";
import { lore } from "../modules/lore"

export function createLoadingStateSystem() {
  get(network).components.LoadingState.update$.subscribe(update => {
    console.log("==> LoadingState system: ", update);
    loadingMessage.set(update.value[0]?.msg + ": " + update.value[0]?.percentage.toFixed(2));
    if (update.value[0]?.state === 2) {
      ready.set(true);
      loadingMessage.set(lore.ready)
    }
  });
}
