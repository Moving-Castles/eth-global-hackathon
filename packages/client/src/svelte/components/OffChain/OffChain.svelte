<script lang="ts">
  import { onMount } from "svelte"
  import { network } from "../../modules/network"
  import { playerAddress } from "../../modules/player"
  import { cores } from "../../modules/entities"
  import throttle from "just-throttle"
  import Icon from "@iconify/svelte"

  type Client = {
    id: string
    address: string
  }

  let verifiedClients: string[] = []
  let cursors: { [key: string]: { x: number; y: number } } = {}
  let socket: any

  $: console.log("cursors", cursors)

  function sendPosition(e) {
    const message = JSON.stringify({
      topic: "MousePosition",
      data: { x: e.clientX, y: e.clientY },
      // data: { x: e.offsetX, y: e.offsetY },
    })
    socket.send(message)
  }

  function getUniqueValues<T>(arr: T[]): T[] {
    return [...new Set(arr)]
  }

  function filterObjectByKey(
    obj: { [key: string]: any },
    keysToKeep: string[]
  ): { [key: string]: any } {
    const filteredObj: { [key: string]: any } = {}

    keysToKeep.forEach(key => {
      if (obj.hasOwnProperty(key)) {
        filteredObj[key] = obj[key]
      }
    })

    return filteredObj
  }

  async function sendVerification() {
    const signature = await $network.network.signer.value_.signMessage("mc")
    const message = JSON.stringify({
      topic: "verify",
      data: { signature: signature },
    })
    socket.send(message)
  }

  onMount(() => {
    socket = new WebSocket("wss://mc.rttskr.com")
    // socket = new WebSocket("ws://localhost:9001")

    // Connection opened
    socket.addEventListener("open", event => {
      sendVerification()
    })

    // Listen for messages
    socket.addEventListener("message", event => {
      console.log("Message from server", event)
      let msgObj = JSON.parse(event.data)
      console.log("msgObj", msgObj)

      // MOUSE POSITION
      if (msgObj.topic === "MousePosition") {
        if (verifiedClients.includes(msgObj.address)) {
          cursors[msgObj.address] = msgObj
        }
      }

      // VERIFIED CLIENTS
      if (msgObj.topic === "verifiedClients") {
        // TODO: do this on server
        console.log("verifiedClients", msgObj.verifiedClients)
        verifiedClients = getUniqueValues(
          msgObj.verifiedClients
            .filter((client: Client) => $cores[client.address])
            .map((client: Client) => client.address)
        )
        cursors = filterObjectByKey(cursors, verifiedClients)
      }
    })
  })
</script>

<svelte:window on:mousemove={throttle(sendPosition, 160)} />

{#each Object.entries(cursors) as [key, value]}
  <div
    class="cursor"
    id={key}
    style={`transform: translateX(${value.x}px) translateY(${value.y}px);`}
  >
    <div class="cursor-icon">
      <Icon icon="game-icons:fairy-wand" />
    </div>
    <div class="cursor-text">
      {$cores[key]?.name}
    </div>
  </div>
{/each}

<div class="cursors">
  {#each Object.entries(cursors) as [key, value]}
    <div>
      {$cores[key]?.name} : {value.x}, {value.y}
    </div>
  {/each}
</div>

<div>
  <div>
    <strong>
      {verifiedClients.length} wizard{verifiedClients.length > 1 ? "s" : ""} present
    </strong>
  </div>
  <div>
    {#each verifiedClients as client}
      <div>
        {$cores[client].name}
        {#if client === $playerAddress}(YOU){/if}
      </div>
    {/each}
  </div>
</div>

<style>
  .cursors {
    position: fixed;
    top: 10px;
    left: 10px;
    z-index: 10000;
    background: lightsalmon;
    font-size: 18px;
  }

  .cursor {
    width: 40px;
    height: 40px;
    top: 0;
    left: 0;
    position: fixed;
    z-index: 10000;
    pointer-events: none;
    transition: transform 0.2s ease-in-out;
    text-align: center;
    display: flex;
    justify-content: center;
    align-items: center;
    flex-wrap: wrap;
    color: white;
  }

  .cursor-icon {
    font-size: 3em;
    opacity: 0.5;
  }

  .cursor-text {
    font-size: 10px;
  }
</style>
