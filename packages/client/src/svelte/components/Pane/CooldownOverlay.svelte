<script lang="ts">
  import { cooldownOnBodies } from "../../modules/state"
  export let id: 1 | 2
</script>

<div class="cooldown-overlay">
  <div class="cooldown-text">
    {$cooldownOnBodies[id]}
  </div>
</div>

<style lang="scss">
  .cooldown-overlay {
    position: absolute;
    top: 50%;
    left: 50%;
    background: rgba(211, 211, 211, 0.4);
    width: 50vh;
    height: 50vh;
    border-radius: 50%;
    backdrop-filter: blur(10px);
    transform: translateX(-50%) translateY(-50%);

    .cooldown-text {
      font-size: 20vh;
      position: absolute;
      top: 50%;
      left: 50%;
      transform: translateX(-50%) translateY(-50%);
      font-family: var(--font-family-special);
    }

    .spinner {
      margin: auto;
      border: 16px solid #f3f3f3;
      border-top: 16px solid #3498db;
      border-radius: 50%;
      width: 120px;
      height: 120px;
      animation: spin 2s linear infinite;
      position: absolute;
      top: 50%;
      left: 50%;
      transform: translateX(-50%) translateY(-50%);
    }
  }

  @keyframes spin {
    0% {
      transform: rotate(0deg);
    }
    100% {
      transform: rotate(360deg);
    }
  }
</style>
