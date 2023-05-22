<script lang="ts">
  import { onMount } from "svelte"
  import { network } from "../../modules/network"
  import { playerAddress } from "../../modules/player"
  import { cores } from "../../modules/entities"

  type Client = {
    id: string
    address: string
  }

  let verifiedClients: string[] = []
  let socket: any

  // function sendMessage() {
  //   const message = JSON.stringify({
  //     topic: "broadcast",
  //     data: { text: textInput },
  //   })
  //   socket.send(message)
  //   textInput = ""
  // }

  function getUniqueValues<T>(arr: T[]): T[] {
    return [...new Set(arr)]
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

    // Connection opened
    socket.addEventListener("open", event => {
      sendVerification()
    })

    // Listen for messages
    socket.addEventListener("message", event => {
      // console.log("Message from server ", event)
      let msgObj = JSON.parse(event.data)
      if (msgObj.topic === "verifiedClients") {
        // TODO: do this on server
        console.log("verifiedClients", msgObj.verifiedClients)
        verifiedClients = getUniqueValues(
          msgObj.verifiedClients
            .filter((client: Client) => $cores[client.address])
            .map((client: Client) => client.address)
        )
      }
    })
  })
</script>

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
