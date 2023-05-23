<script lang="ts">
  import { ActionType } from "../../modules/entities"
  import { getContext } from "svelte"
  import Icon from "@iconify/svelte"

  export let playerVote: number

  const vote = getContext("vote")
  const icons = getContext("icons")

  function attackOne() {
    vote(ActionType.ATTACK_ONE)
  }

  function attackTwo() {
    vote(ActionType.ATTACK_TWO)
  }

  function attackThree() {
    vote(ActionType.ATTACK_THREE)
  }

  function heal() {
    vote(ActionType.HEAL)
  }

  function taunt() {
    vote(ActionType.TAUNT)
  }
</script>

<div class="votes" class:disabled={!isNaN(playerVote) && playerVote !== 0}>
  <button
    class="button vote-button"
    disabled={!isNaN(playerVote) && playerVote !== 0}
    on:click={attackOne}
  >
    ATTACK 1 <Icon icon={icons[1]} />
  </button>
  <button
    class="button vote-button"
    disabled={!isNaN(playerVote) && playerVote !== 0}
    on:click={attackTwo}
  >
    ATTACK 2 <Icon icon={icons[2]} />
  </button>
  <button
    class="button vote-button"
    disabled={!isNaN(playerVote) && playerVote !== 0}
    on:click={attackThree}
  >
    ATTACK 3 <Icon icon={icons[3]} />
  </button>
  <button
    class="button vote-button"
    disabled={!isNaN(playerVote) && playerVote !== 0}
    on:click={heal}
  >
    HEAL <Icon icon={icons[4]} />
  </button>
  <button
    class="button vote-button"
    disabled={!isNaN(playerVote) && playerVote !== 0}
    on:click={taunt}
  >
    TAUNT <Icon icon={icons[5]} />
  </button>
</div>
