const lerp = (x: number, y: number, a: number) => x * (1 - a) + y * a;

const radial = (t: number, feather = 5) => {
  const invT = lerp(1, 0, t)
  return `
  position: fixed;
  z-index: 9;
  -webkit-mask-image: radial-gradient( #0000 ${invT * 100}%, #ffff ${(invT * 100) + feather}%);
  mask-image: radial-gradient( #0000 ${invT * 100}%, #ffff ${(invT * 100) + feather}%);
  -webkit-mask-size: 100vmax 100vmax;
  mask-size: 100vmax 100vmax;
  mask-position: 50% 50%;
`
}

const diamond = (t: number, feather = 5) => {
  const invT = lerp(1, 0, t)
  return `
  position: fixed;
  z-index: 9;
  -webkit-mask-image: radial-gradient( #0000 ${invT * 100}%, #ffff ${(invT * 100) + feather}%);
  mask-image: radial-gradient( #0000 ${invT * 100}%, #ffff ${(invT * 100) + feather}%);
  -webkit-mask-size: 100vw 100vh;
  mask-size: 100vw 100vh;
  mask-position: 50% 50%;
`
}

const topToBottom = (t: number, feather = 5) => {
  const invT = lerp(1, 0, t)
  return `
  position: fixed;
  z-index: 9;
  -webkit-mask-image: linear-gradient( #0000 ${invT * 100}%, #ffff ${(invT * 100) + feather}%);
  mask-image: linear-gradient( #0000 ${invT * 100}%, #ffff ${(invT * 100) + feather}%);
  -webkit-mask-size: 100vmax 100vmax;
  mask-size: 100vmax 100vmax;
  mask-position: 50% 50%;
`
}

const bottomToTop = (t: number, feather = 5) => {
  return `
  position: fixed;
  z-index: 9;
  -webkit-mask-image: linear-gradient( #ffff ${t * 100}%, #0000 ${(t * 100) + feather}%);
  mask-image: linear-gradient( #ffff ${t * 100}%, #0000 ${(t * 100) + feather}%);
  -webkit-mask-size: 100vmax 100vmax;
  mask-size: 100vmax 100vmax;
  mask-position: 50% 50%;
`
}

const leftToRight = (t: number, feather = 5) => {
  return `
  position: fixed;
  z-index: 9;
  -webkit-mask-image: linear-gradient(to left,  #ffff ${t * 100}%, #0000 ${(t * 100) + feather}%);
  mask-image: linear-gradient(to left,  #ffff ${t * 100}%, #0000 ${(t * 100) + feather}%);
  -webkit-mask-size: 100vmax 100vmax;
  mask-size: 100vmax 100vmax;
  mask-position: 50% 50%;
`
}

const rightToLeft = (t: number, feather = 5) => {
  return `
  position: fixed;
  z-index: 9;
  -webkit-mask-image: linear-gradient(to right,  #ffff ${t * 100}%, #0000 ${(t * 100) + feather}%);
  mask-image: linear-gradient(to right,  #ffff ${t * 100}%, #0000 ${(t * 100) + feather}%);
  -webkit-mask-size: 100vmax 100vmax;
  mask-size: 100vmax 100vmax;
  mask-position: 50% 50%;
`
}

const angled = (t: number, angle: number, feather = 5) => {
  return `
  position: fixed;
  z-index: 9;
  -webkit-mask-image: linear-gradient(${angle}deg,  #ffff ${t * 100}%, #0000 ${(t * 100) + feather}%);
  mask-image: linear-gradient(${angle}deg,  #ffff ${t * 100}%, #0000 ${(t * 100) + feather}%);
  -webkit-mask-size: 100vmax 100vmax;
  mask-size: 100vmax 100vmax;
  mask-position: 50% 50%;
`
}

const wipe = (t: number, angle = 0) => {
  // 0 state
  // all white
  // 0.5 state
  // white black white
  // 1 state
  // black
  const whiteLeft = lerp(0, 0.5, t)
  const whiteRight = lerp(1, 0.5, t)

  return `
  position: fixed;
  z-index: 9;
  -webkit-mask-image: linear-gradient(${angle}deg, #ffff ${whiteLeft * 100}%, #0000, #ffff ${whiteRight * 100}%);
  mask-image: linear-gradient(${angle}deg, #ffff ${whiteLeft * 100}%, #0000, #ffff ${whiteRight * 100}%);
  -webkit-mask-size: 100vmax 100vmax;
  mask-size: 100vmax 100vmax;
  mask-position: 50% 50%;
`
}

export function mask (node, {
  delay = 0,
  duration = 400,
  type = 'radial',
  feather = 5
}) {
  return {
    delay,
    duration,
    css: t => {
      switch (type) {
        case ('radial'):
          return radial(t, feather)
        case ('topToBottom'):
          return topToBottom(t, feather)
        case ('bottomToTop'):
          return bottomToTop(t, feather)
        case ('leftToRight'):
          return leftToRight(t, feather)
        case ('rightToLeft'):
          return rightToLeft(t, feather)
        case ('topRightToBottomLeft'):
          return angled(t, 45, feather)
        case ('topLeftToBottomRight'):
          return angled(t, -45, feather)
        case ('bottomLeftToTopRight'):
          return angled(t, -135, feather)
        case ('bottomRightToTopLeft'):
          return angled(t, 135, feather)
        // Broken
        case ('wipeVertical'):
          return wipe(t)
        case ('wipeHorizontal'):
          return wipe(t, 90)
        case ('diamond'):
          return diamond(t, feather)
      }
    }
  };
}
