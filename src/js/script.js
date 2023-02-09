// Quick 1D Perlin noise
// ref: https://github.com/SRombauts/SimplexNoise/blob/master/src/SimplexNoise.cpp#L166

class Perlin {
  constructor() {
    // Quick and dirty permutation table
    this.perm = (() => {
      const tmp = Array.from({ length: 256 }, () =>
        Math.floor(Math.random() * 256)
      );
      return tmp.concat(tmp);
    })();
  }

  grad(i, x) {
    const h = i & 0xf;
    const grad = 1 + (h & 7);

    if ((h & 8) !== 0) {
      return -grad * x;
    }

    return grad * x;
  }

  getValue(x) {
    const i0 = Math.floor(x);
    const i1 = i0 + 1;

    const x0 = x - i0;
    const x1 = x0 - 1;

    let t0 = 1 - x0 * x0;
    t0 *= t0;

    let t1 = 1 - x1 * x1;
    t1 *= t1;

    const n0 = t0 * t0 * this.grad(this.perm[i0 & 0xff], x0);
    const n1 = t1 * t1 * this.grad(this.perm[i1 & 0xff], x1);

    return 0.395 * (n0 + n1);
  }
}

const sample = [
  0.03, 0.03, 0.03, 0.04, 0.07, 0.23, 0.18, 0.5, 0.85, 1, 0.78, 0.7, 0.5, 0.3,
  0.12, 0.07, 0.23, 0.5, 0.58, 0.4, 0.2, 0.13, 0.05, 0.15, 0.2, 0.15, 0.12,
  0.08, 0.05, 0.04, 0.03, 0.03, 0.23, 0.5, 0.58, 0.4, 0.2, 0.13, 0.05, 0.15,
  0.2, 0.15, 0.12, 0.08, 0.05, 0.04, 0.03, 0.03, 0.15, 0.12, 0.08, 0.05, 0.04,
  0.03, 0.03, 0.2, 0.13, 0.05, 0.15, 0.05, 0.15,
];

const jumpTime = 125;

const segmentElements = [];

const spectrumElement = document.querySelectorAll(".spectrum");
console.log(spectrumElement);
// Set init sizes of each segment
sample.forEach((value, i) => {
  const segment = document.createElement("div");
  segment.classList.add("spectrum-segment");
  segmentElements.push(segment);
  spectrumElement.forEach((s) => s.appendChild(segment));
});

function jump() {
  const noise = new Perlin();

  segmentElements.forEach((segmentElement, i) => {
    let value =
      // normalize [-1, 1] => [0, 1]
      ((noise.getValue(i * 0.1) + 1) / 2) *
      // multiply by random value
      Math.random() *
      sample[i];

    // Adding a minimum
    value = value < 0.01 ? 0.01 : value;

    // segmentElement.style.transition = `transform ${ jumpTime }ms linear`;
    segmentElement.style.transform = `scale3d(1, ${value}, 1)`;
  });
}

setInterval(() => requestAnimationFrame(jump), jumpTime);




// Quick 1D Perlin noise
// ref: https://github.com/SRombauts/SimplexNoise/blob/master/src/SimplexNoise.cpp#L166

class Perlin2 {
  constructor() {
    // Quick and dirty permutation table
    this.perm = (() => {
      const tmp = Array.from({ length: 256 }, () =>
        Math.floor(Math.random() * 256)
      );
      return tmp.concat(tmp);
    })();
  }

  grad(i, x) {
    const h = i & 0xf;
    const grad = 1 + (h & 7);

    if ((h & 8) !== 0) {
      return -grad * x;
    }

    return grad * x;
  }

  getValue(x) {
    const i0 = Math.floor(x);
    const i1 = i0 + 1;

    const x0 = x - i0;
    const x1 = x0 - 1;

    let t0 = 1 - x0 * x0;
    t0 *= t0;

    let t1 = 1 - x1 * x1;
    t1 *= t1;

    const n0 = t0 * t0 * this.grad(this.perm[i0 & 0xff], x0);
    const n1 = t1 * t1 * this.grad(this.perm[i1 & 0xff], x1);

    return 0.395 * (n0 + n1);
  }
}



const sample2 = [
  0.03, 0.03, 0.03, 0.04, 0.07, 0.23, 0.18, 0.5, 0.85, 1, 0.78, 0.7, 0.5, 0.3,
  0.12, 0.07, 0.23, 0.5, 0.58, 0.4, 0.2, 0.13, 0.05, 0.15, 0.2, 0.15, 0.12,
  0.08, 0.05, 0.04, 0.03, 0.03, 0.23, 0.5, 0.58, 0.4, 0.2, 0.13, 0.05, 0.15,
  0.2, 0.15, 0.12, 0.08, 0.05, 0.04, 0.03, 0.03, 0.15, 0.12, 0.08, 0.05, 0.04,
  0.03, 0.03, 0.2, 0.13, 0.05, 0.15, 0.05, 0.15,
];

const jumpTime2 = 125;


const segmentElements2 = [];

const spectrumElement2 = document.querySelectorAll(".spectrum2");
// Set init sizes of each segment
sample2.forEach((value, i) => {
  const segment2 = document.createElement("div");
  segment2.classList.add("spectrum-segment2");
  segmentElements2.push(segment2);
  spectrumElement2.forEach((s) => s.appendChild(segment2));
});

function jump2() {
  const noise2 = new Perlin2();

  segmentElements2.forEach((segmentElement2, i) => {
    let value =
      // normalize [-1, 1] => [0, 1]
      ((noise2.getValue(i * 0.1) + 1) / 2) *
      // multiply by random value
      Math.random() *
      sample2[i];

    // Adding a minimum
    value = value < 0.01 ? 0.01 : value;

    // segmentElement.style.transition = `transform ${ jumpTime }ms linear`;
    segmentElement2.style.transform = `scale3d(1, ${value}, 1)`;
  });
}

setInterval(() => requestAnimationFrame(jump2), jumpTime2);





class Perlin3 {
  constructor() {
    // Quick and dirty permutation table
    this.perm = (() => {
      const tmp = Array.from({ length: 256 }, () =>
        Math.floor(Math.random() * 256)
      );
      return tmp.concat(tmp);
    })();
  }

  grad(i, x) {
    const h = i & 0xf;
    const grad = 1 + (h & 7);

    if ((h & 8) !== 0) {
      return -grad * x;
    }

    return grad * x;
  }

  getValue(x) {
    const i0 = Math.floor(x);
    const i1 = i0 + 1;

    const x0 = x - i0;
    const x1 = x0 - 1;

    let t0 = 1 - x0 * x0;
    t0 *= t0;

    let t1 = 1 - x1 * x1;
    t1 *= t1;

    const n0 = t0 * t0 * this.grad(this.perm[i0 & 0xff], x0);
    const n1 = t1 * t1 * this.grad(this.perm[i1 & 0xff], x1);

    return 0.395 * (n0 + n1);
  }
}



const sample3 = [
  0.03, 0.03, 0.03, 0.04, 0.07, 0.23, 0.18, 0.5, 0.85, 1, 0.78, 0.7, 0.5, 0.3,
  0.12, 0.07, 0.23, 0.5, 0.58, 0.4, 0.2, 0.13, 0.05, 0.15, 0.2, 0.15, 0.12,
  0.08, 0.05, 0.04, 0.03, 0.03, 0.23, 0.5, 0.58, 0.4, 0.2, 0.13, 0.05, 0.15,
  0.2, 0.15, 0.12, 0.08, 0.05, 0.04, 0.03, 0.03, 0.15, 0.12, 0.08, 0.05, 0.04,
  0.03, 0.03, 0.2, 0.13, 0.05, 0.15, 0.05, 0.15,
  0.03, 0.03, 0.03, 0.04, 0.07, 0.23, 0.18, 0.5, 0.85, 1, 0.78, 0.7, 0.5, 0.3,
  0.12, 0.07, 0.23, 0.5, 0.58, 0.4, 0.2, 0.13, 0.05, 0.15, 0.2, 0.15, 0.12,
  0.08, 0.05, 0.04, 0.03, 0.03, 0.23, 0.5, 0.58, 0.4, 0.2, 0.13, 0.05, 0.15,
  0.2, 0.15, 0.12, 0.08, 0.05, 0.04, 0.03, 0.03, 0.15, 0.12, 0.08, 0.05, 0.04,
  0.03, 0.03, 0.2, 0.13, 0.05, 0.15, 0.05, 0.15,
  0.03, 0.03, 0.03, 0.04, 0.07, 0.23, 0.18, 0.5, 0.85, 1, 0.78, 0.7, 0.5, 0.3,
  0.12, 0.07, 0.23, 0.5, 0.58, 0.4, 0.2, 0.13, 0.05, 0.15, 0.2, 0.15, 0.12,
  0.08, 0.05, 0.04, 0.03, 0.03, 0.23, 0.5, 0.58, 0.4, 0.2, 0.13, 0.05, 0.15,
  0.2, 0.15, 0.12, 0.08, 0.05, 0.04, 0.03, 0.03, 0.15, 0.12, 0.08, 0.05, 0.04,
  0.03, 0.03, 0.2, 0.13, 0.05, 0.15, 0.05, 0.15,
];

const jumpTime3 = 125;


const segmentElements3 = [];

const spectrumElement3 = document.querySelectorAll(".spectrum3");
// Set init sizes of each segment
sample3.forEach((value, i) => {
  const segment3 = document.createElement("div");
  segment3.classList.add("spectrum-segment3");
  segmentElements3.push(segment3);
  spectrumElement3.forEach((s) => s.appendChild(segment3));
});

function jump3() {
  const noise3 = new Perlin3();

  segmentElements3.forEach((segmentElement3, i) => {
    let value =
      // normalize [-1, 1] => [0, 1]
      ((noise3.getValue(i * 0.1) + 1) / 2) *
      // multiply by random value
      Math.random() *
      sample3[i];

    // Adding a minimum
    value = value < 0.01 ? 0.01 : value;

    // segmentElement.style.transition = `transform ${ jumpTime }ms linear`;
    segmentElement3.style.transform = `scale3d(1, ${value}, 1)`;
  });
}

setInterval(() => requestAnimationFrame(jump3), jumpTime3);


