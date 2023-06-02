<script lang="ts">
  import { TimelineMax } from "gsap"
  import {
    activeActions,
    queuedActions,
    completedActions,
    failedActions,
    sequencerState,
    SequencerState,
  } from "../../modules/action/actionSequencer"
  import { playSound } from "../../../howler"
  import { WorldFunctions } from "../../modules/action"

  // function toggleSequencer() {
  //   sequencerState.set($sequencerState)
  //   if ($sequencerState === SequencerState.Running) {
  //     playSound("eventBad", "ui")
  //     sequencerState.set(SequencerState.Paused)
  //   } else {
  //     playSound("eventGood", "ui")
  //     sequencerState.set(SequencerState.Running)
  //   }
  // }

  let queueElement: HTMLElement
  let activeElement: HTMLElement
  let doneElement: HTMLElement
  let coreConnector: HTMLElement
  let queueConnector: HTMLElement
  let activeConnector: HTMLElement

  let localQueuedActionsCount = 0
  let localActiveActionsCount = 0
  let localCompletedActionsCount = 0
  let localFailedActionsCount = 0

  const CONNECTOR_TIME = 0.1
  const NODE_TIME = 0.4

  function animateAction(
    connectorEl: HTMLElement,
    nodeEl: HTMLElement,
    nodeColor: string
  ) {
    const tl2 = new TimelineMax()
    tl2.to(connectorEl, 0, { height: 0 })
    tl2.to(connectorEl, CONNECTOR_TIME, { height: 100, opacity: 1 })
    tl2.to(nodeEl, 0, { backgroundColor: nodeColor })
    tl2.to(nodeEl, NODE_TIME, { backgroundColor: "#808080" })
  }

  function animateQueuedAction() {
    animateAction(coreConnector, queueElement, "orange")
  }

  function animateActiveAction() {
    animateAction(queueConnector, activeElement, "orange")
  }

  function animateCompletedAction() {
    animateAction(activeConnector, doneElement, "green")
  }

  function animateFailedAction() {
    animateAction(activeConnector, doneElement, "red")
  }

  function clearConnectors() {
    const tl2 = new TimelineMax()
    tl2.to(coreConnector, 0.3, { opacity: 0 }, "end")
    tl2.to(queueConnector, 0.3, { opacity: 0 }, "end")
    tl2.to(activeConnector, 0.3, { opacity: 0 }, "end")
  }

  queuedActions.subscribe(actions => {
    if (actions.length > localQueuedActionsCount) animateQueuedAction()
    setTimeout(() => {
      // playSound("item", "ui")
      localQueuedActionsCount = actions.length
    }, CONNECTOR_TIME * 1000)
  })

  activeActions.subscribe(actions => {
    if (actions.length > localActiveActionsCount) animateActiveAction()
    setTimeout(() => {
      // playSound("item", "ui")
      localActiveActionsCount = actions.length
    }, CONNECTOR_TIME * 1000)
  })

  completedActions.subscribe(actions => {
    if (actions.length > localCompletedActionsCount) animateCompletedAction()
    setTimeout(() => {
      if (actions.length === 0) return
      console.log(actions[0].systemId)
      if (actions[0].systemId == WorldFunctions.Start) {
        playSound("tekken", "gameStart")
      } else {
        playSound("tekken", "yes")
      }
      localCompletedActionsCount = actions.length
      clearConnectors()
    }, CONNECTOR_TIME * 1000)
  })

  failedActions.subscribe(actions => {
    if (actions.length > localFailedActionsCount) animateFailedAction()
    setTimeout(() => {
      // playSound("tekken", "no")
      localFailedActionsCount = actions.length
      clearConnectors()
    }, CONNECTOR_TIME * 1000)
  })
</script>

<div class="executor">
  <div class="node queue" bind:this={queueElement}>
    <div>{localQueuedActionsCount}</div>
  </div>
  <div class="node active" bind:this={activeElement}>
    <div>{localActiveActionsCount}</div>
  </div>
  <div class="node done" bind:this={doneElement}>
    <div>
      {localCompletedActionsCount}/{localFailedActionsCount}
    </div>
  </div>
</div>

<style lang="scss">
  progress {
    height: 25px;
  }

  .executor {
    overflow: hidden;
    height: auto;
    height: 30px;
    display: flex;
    flex-direction: row;
    background: black;
    z-index: 10000;

    .node {
      height: 30px;
      width: 30px;
      background: #808080;
      font-size: 10px;
      display: flex;
      justify-content: center;
      align-items: center;

      &.queue {
        &.focus {
          background: yellow;
          color: black;
        }
      }

      &.active {
        &.focus {
          background: orangered;
          color: black;
        }
      }

      &.active {
        &.focus {
          background: green;
        }
      }
    }
  }
</style>
