<script lang="ts">
  import { lore } from "../../modules/content/lore"
  import { spawn } from "../../modules/action"
  let name = lore.names[Math.floor(Math.random() * lore.names.length)]
</script>

<div class="spawn">
  We welcome <br />
  <div class="avatar-creation">
    <form
      on:submit|preventDefault={() => {
        spawn(name)
      }}
    >
      <input id="name" type="text" bind:value={name} />
    </form>
  </div>
  <button
    on:click={() => {
      spawn(name)
    }}>SPAWN</button
  >
</div>

<style lang="scss">
  .spawn {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: #ff0000;
    display: flex;
    gap: 3rem;
    flex-flow: column;
    justify-content: center;
    align-items: center;
    text-align: center;
    font-size: 3rem;
  }

  input {
    background: black;
    color: red;
    font-family: monospace;
    text-align: center;
    font-size: 3rem;
  }
</style>
