<div align="center">

# 🔄 FFT Magnitude ↔ Phase Swap

### *What matters more in an image — the magnitude or the phase?*

[![MATLAB](https://img.shields.io/badge/MATLAB-R2020b%2B-orange?logo=mathworks&logoColor=white)](https://www.mathworks.com/)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Status](https://img.shields.io/badge/status-complete-brightgreen)]()

A hands-on MATLAB experiment in 2D Fourier analysis: swap the magnitude and phase spectra of two images and watch which one "wins."

</div>

---

## 📖 The Idea

Every image, once transformed with a 2D FFT, splits into two independent pieces of information:

| Component | Symbol | What it (roughly) encodes |
|---|---|---|
| **Magnitude** | `|F(u,v)|` | Contrast, texture, energy per frequency |
| **Phase** | `∠F(u,v)` | *Where things are* — edges, shapes, structure |

This project answers a simple but surprisingly striking question: if you take the magnitude of **Image A** and the phase of **Image B**, then inverse-transform it back into the spatial domain — **which image do you end up looking at?**

Spoiler: it looks like **B**. Phase carries almost all the recognizable structure of an image; magnitude mostly just adds texture on top. This repo reconstructs that result from scratch and backs it up with a quantitative MSE comparison.

---

## ✨ Features

- 🖼️ Grayscale conversion + automatic resizing so any two input images just work
- 📊 2D FFT decomposition into magnitude and phase
- 🌈 Log-scaled, zero-shifted magnitude spectrum visualization
- 🔀 Magnitude/phase swapping and inverse-FFT reconstruction
- 📈 Quantitative MSE check confirming which original each hybrid resembles
- 💾 Every intermediate and final result auto-saved to `outputs/`
- 🧩 Clean, portable code — no hardcoded paths, works on any OS

---

## 🖥️ Example Output

Running the script produces a 2×2 comparison figure:

```
┌───────────────────┬───────────────────┐
│    Original 1      │    Original 2      │
├───────────────────┼───────────────────┤
│  |F1| + phase(F2)  │  |F2| + phase(F1)  │
└───────────────────┴───────────────────┘
```

...plus side-by-side magnitude spectra and a console readout like:

```
MSE(mag1+phase2, Image1) = 0.04213   MSE(mag1+phase2, Image2) = 0.00871
MSE(mag2+phase1, Image1) = 0.00932   MSE(mag2+phase1, Image2) = 0.03987
Lower MSE against the image that donated the PHASE confirms phase
carries most of the recognizable structure.
```

---

## 🚀 Getting Started

### Prerequisites
- MATLAB (R2020b or newer recommended)
- Image Processing Toolbox

### Run it

```bash
git clone https://github.com/Armin-Il/fft-magnitude-phase-swap.git
cd fft-magnitude-phase-swap
```

1. Drop two images named `pic1.png` and `pic2.png` into the `images/` folder (or edit the paths at the top of the script).
2. Open MATLAB and run:

```matlab
fft2_magnitude_phase_swap
```

3. Check the `outputs/` folder for all generated images and figures.

---

## 📁 Project Structure

```
fft-magnitude-phase-swap/
├── fft2_magnitude_phase_swap.m   # Main script
├── images/                       # Put your input images here
├── outputs/                      # Generated results land here
└── README.md
```

---

## 🧠 Why This Matters

This isn't just a party trick — the magnitude/phase asymmetry is the theoretical backbone of several real techniques:

- **Phase correlation** for image registration and motion estimation
- **Phase-only reconstruction** as a robustness benchmark in compression research
- Intuition for **why JPEG-style compression can be aggressive with magnitude/texture info** but must protect phase-adjacent structural information

---

## 🎓 Background

Originally built as a course project for **Engineering Mathematics**, reworked here into a clean, portable, GitHub-ready form.

## 📜 License

MIT — feel free to use, modify, and learn from this.

---

<div align="center">
Made with MATLAB, `fft2`, and a healthy curiosity about what actually makes an image look like itself.
</div>
