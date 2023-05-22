<script lang="ts">
  import { onMount } from "svelte"
  import { network } from "../../modules/network"
  import { playerAddress } from "../../modules/player"
  import { cores } from "../../modules/entities"

  // import { v4 as uuid } from "uuid"

  type Client = {
    id: string
    address: string
  }

  let verifiedClients: Client[] = []
  let socket: any

  // function sendMessage() {
  //   const message = JSON.stringify({
  //     topic: "broadcast",
  //     data: { text: textInput },
  //   })
  //   socket.send(message)
  //   textInput = ""
  // }

  async function sendVerification() {
    const signature = await $network.network.signer.value_.signMessage("mc")
    const message = JSON.stringify({
      topic: "verify",
      data: { signature: signature },
    })
    socket.send(message)
  }

  onMount(() => {
    // uuid = uuid()
    socket = new WebSocket("wss://mc.rttskr.com")

    // Connection opened
    socket.addEventListener("open", event => {
      console.log("Connected")
      sendVerification()
    })

    // Listen for messages
    socket.addEventListener("message", event => {
      // console.log("Message from server ", event)
      let msgObj = JSON.parse(event.data)
      if (msgObj.topic === "verifiedClients") {
        verifiedClients = msgObj.verifiedClients
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
        {$cores[client.address]?.name}
        {#if client.address === $playerAddress}(YOU){/if}
      </div>
    {/each}
  </div>
</div>
