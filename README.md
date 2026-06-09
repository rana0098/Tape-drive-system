# 🎞️ Tape Drive System — Modeling, Control & System Identification

> **Course:** Soft Sensing and System Identification  
> **Student:** Rana Sanjideh (571482) — rana.sanjideh@studenti.unime.it  
> **University:** Università degli Studi di Messina  
> **Tools:** MATLAB · Simulink · System Identification Toolbox

---

## 📌 Overview

This project presents a complete control systems analysis of a **DC motor-driven computer tape drive**. The system consists of a motorized capstan, an elastic tape coupling (spring `K` + damper `B`), and a passive idler wheel. The full pipeline covers physics-based modeling, Simulink simulation, PID control design, and data-driven system identification using ARX and FIR models.

---

## 🏗️ System Description

The tape drive is modeled as a **6th-order state-space LTI system** driven by motor current `iₐ`.

```
State vector:  x = [ω₁, x₁, v₁, ω₂, x₂, v₂]ᵀ
Input:         u = iₐ  (motor current [A])
Output:        y = [x₁, v₁, x₂, v₂]ᵀ
```

### Governing Equations

| Equation | Description |
|----------|-------------|
| `J₁·ω̇₁ = Kt·iₐ - B₁·ω₁ - r₁·F_coupling` | Capstan angular velocity |
| `ẋ₁ = v₁` | Capstan position |
| `v̇₁ = r₁·ω̇₁` | Capstan linear velocity |
| `J₂·ω̇₂ = -B₂·ω₂ + r₂·F_coupling` | Idler angular velocity |
| `ẋ₂ = v₂` | Idler position |
| `v̇₂ = r₂·ω̇₂` | Idler linear velocity |

Where the **tape coupling force** is:
```
F_coupling = K·(x₂ - x₁) + B·(v₂ - v₁)
```

### System Parameters

| Parameter | Value | Description |
|-----------|-------|-------------|
| `J₁` | 5×10⁻⁵ kg·m² | Motor + capstan inertia |
| `B₁` | 1×10⁻² N·m·s | Motor damping |
| `r₁` | 2×10⁻² m | Capstan radius |
| `Kt` | 3×10⁻² N·m/A | Motor torque constant |
| `K` | 2×10⁴ N/m | Tape spring stiffness |
| `B` | 20 N·m·s | Tape damping |
| `r₂` | 2×10⁻² m | Idler radius |
| `J₂` | 2×10⁻⁵ kg·m² | Idler inertia |
| `B₂` | 2×10⁻² N·m·s | Idler damping |


---

## 📁 Project Structure

```
├── Part1_Simulation/       # Simulink models & parameter sweeps
├── Part2_ModelApprox/      # 2nd-order approximation & step response
├── Part3_Identification/   # ARX and FIR model identification
├── report_Tape_drive.docx  # Full written report
└── README.md
```

---

## 🔬 Part 1 — Simulation & Linearity Verification

**Objectives:**
- Build a Simulink model from the state-space equations
- Simulate behavior under step and sinusoidal inputs for varying parameters
- Verify system linearity via the **Superposition Principle**

**Key Results:**

| Signal | Steady-State | Rise Time | Overshoot | Settling Time |
|--------|-------------|-----------|-----------|---------------|
| `v₁` (capstan velocity) | 0.020 m/s | ~2–3 ms | ~21% | ~15 ms |
| `v₂` (idler velocity) | 0.020 m/s | ~50–80 ms | 0% | ~100 ms |

- **Linearity confirmed** via Homogeneity test (scaling factor `k=2`): outputs scaled exactly 1:2 in both steady-state and transient phases, confirming **LTI** behavior.
- **PID controller** designed and tuned for tape speed `ẋ₁` in Simulink.

**Parameter sensitivity findings:**
- Reducing stiffness `K` introduces phase lag and permanent tape stretch under load
- Increasing idler inertia `J₂` significantly increases rise time and position error between capstan and idler

---

## 📈 Part 2 — Transfer Function & 2nd-Order Approximation

**Objectives:**
- Derive the transfer function from motor current `Iₐ(s)` to tape position `X₁(s)`
- Identify step response characteristics
- Approximate with a dominant 2nd-order model

**Transfer Function:**
```
X₁(s)     Kt·r₁·[J₂s² + (B₂ + r₂²B)s + r₂²K]
------ = ─────────────────────────────────────────────
Iₐ(s)    s·[J₁J₂s³ + (...)s² + (...)s + r₁²B₂K + r₂²B₁K]
```

**Poles:** `0, -380 ± j309, -1000`  
**Zeros:** `-400, -1000`

**2nd-Order Approximation results:**
- Captures **22% overshoot** and resonant peak at **300 rad/s**
- Bode analysis confirms excellent correlation with the full-order model
- High-frequency poles verified to have a negligible effect on operational bandwidth

---

## 🧠 Part 3 — System Identification (ARX & FIR)

**Objectives:**
- Identify ARX and FIR models from simulated I/O data
- Estimate model order using standard techniques
- Validate models in time and frequency domains

### ARX Model

| Metric | Result |
|--------|--------|
| Model order | 10th-order |
| Prediction fit (NRMSE) | **99.21%** |
| Residuals | White noise (within 99% CI) |
| Poles | All stable, inside unit circle |

- Step response tracking: near-perfect match including overshoot (peak ~0.024) and settling behavior
- Pole-Zero map confirms correct identification of resonant frequency and damping

### FIR Model

| Metric | Result |
|--------|--------|
| Prediction fit | High (comparable to ARX) |
| Magnitude match | Identical across full frequency range, including resonant peak |
| Phase | Linear lag at high frequencies (>1000 rad/s) due to group delay |

- Impulse response coefficients decay to zero → confirms **stable** system
- Negative coefficient stems (~0.007s) capture the oscillatory nature of the elastic tape

### Conclusion

> Both the ARX and FIR models successfully captured the tape drive dynamics. The ARX model achieves a **99.21% prediction accuracy** with white residuals, making it the preferred candidate for digital controller implementation. The FIR model provides complementary validation through its inherently stable structure and perfect magnitude matching.

---

## ⚙️ Requirements

- **MATLAB** R2020b or later
- **Simulink**
- **System Identification Toolbox**
- **Control System Toolbox**

---

## 🚀 Getting Started

1. Clone the repository:
   ```bash
   git clone https://github.com/<your-username>/tape-drive-system.git
   cd tape-drive-system
   ```

2. Open MATLAB and navigate to the project folder.

3. Run Part 1 simulation:
   ```matlab
   open('Part1_Simulation/tape_drive_model.slx')
   ```

4. Run system identification (Part 3):
   ```matlab
   run('Part3_Identification/arx_fir_identification.m')
   ```

---

## 📬 Contact

**Rana Sanjideh** — rana.sanjideh@studenti.unime.it  
Università degli Studi di Messina, Italy
