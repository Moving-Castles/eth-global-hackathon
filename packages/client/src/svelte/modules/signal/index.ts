import type { Toast } from "../../modules/ui/toast"
import { toastMessage } from "../../modules/ui/toast"
import { get, writable } from "svelte/store"
import { network } from "../network"
import { cores } from "../state"
import { filterObjectByKey, getUniqueValues } from "../../utils/misc"

// --- TYPES -------------------------------------------------------------------

type Client = {
    id: string
    address: string
}

// --- CONSTANTS --------------------------------------------------------------

const SIGNAL_SERVER_URL = "wss://mc.rttskr.com"
const MESSAGE = "mc"

// --- STORES -----------------------------------------------------------------

export let verifiedClients = writable([] as string[])
export let cursors = writable({} as { [key: string]: { x: number; y: number } })
export let cheering = writable(false)

let socket: any

export function initSignalNetwork() {
    socket = new WebSocket(SIGNAL_SERVER_URL)

    // Connection opened, verify address
    socket.addEventListener("open", sendVerification)

    // Listen for messages
    socket.addEventListener("message", (event: { data: string }) => {
        // console.log("Message from server ", event.data)
        let msgObj = JSON.parse(event.data)

        // MOUSE POSITION
        if (msgObj.topic === "MousePosition") {
            if (get(verifiedClients).includes(msgObj.address)) {
                cursors.update((cursors) => {
                    cursors[msgObj.address] = msgObj
                    return cursors;
                })
            }
        }

        // VERIFIED CLIENTS
        if (msgObj.topic === "verifiedClients") {
            // TODO: do this on server ??
            // Verified clients changed: dedupe and filter to cores in current world
            verifiedClients.update((verifiedClients) => {
                verifiedClients = getUniqueValues(
                    msgObj.verifiedClients
                        .filter((client: Client) => get(cores)[client.address])
                        .map((client: Client) => client.address))
                return verifiedClients;
            })
            // Remove offline clients from cursor store
            cursors.update((cursors) => {
                cursors = filterObjectByKey(cursors, get(verifiedClients));
                return cursors;
            })
        }

        // CHEER
        if (msgObj.topic === "cheer") {
            cheering.set(true);
        }

        // CHEER
        if (msgObj.topic === "toast") {
            console.log('receive toast')
            console.log(msgObj.data.message)
            toastMessage(msgObj.data.message)
        }
    })
}

async function sendVerification() {
    const signature = await get(network).network.signer.value_.signMessage(MESSAGE)
    const message = JSON.stringify({
        topic: "verify",
        data: { signature: signature },
    })
    socket.send(message)
}

export function sendPosition(e: { clientX: number; clientY: number }) {
    const message = JSON.stringify({
        topic: "MousePosition",
        data: { x: e.clientX, y: e.clientY },
    })
    socket.send(message)
}

export function sendCheer() {
    socket.send(JSON.stringify({ topic: "cheer" }))
}

export function sendToast(message: string) {
    const options = { timestamp: performance.now(), type: "warning", disappear: true }
    const toast = { message, ...options} as Toast
    // For local player
    toastMessage(message, options)
    // For world
    socket.send(JSON.stringify({ topic: "toast", data: toast }))
}