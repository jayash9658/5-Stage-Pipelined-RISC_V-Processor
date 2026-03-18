# 5-Stage-Pipelined-RISC_V-Processor
# 🚀 RISC-V Processor Design (RV64I Subset)

A complete implementation of a **RISC-V RV64I processor** in Verilog, including:

* ✅ Single-Cycle Processor
* ✅ 5-Stage Pipelined Processor
* ✅ Hazard Detection & Forwarding
* ✅ Simulation & Verification

📄 Detailed reports:

*  (Pipelined Processor)
*  (Single-Cycle Processor)

---
<img width="2124" height="1351" alt="image" src="https://github.com/user-attachments/assets/ea013155-f4c5-4bdc-8109-85681ada0c10" />
---
## 📌 Overview

This project implements a **64-bit RISC-V processor** supporting a subset of the RV64I ISA.

Two architectures are designed:

### 🔹 Single-Cycle Processor

* Executes one instruction per clock cycle
* Simpler control and datapath
* Longer clock period (limited by slowest instruction)

### 🔹 Pipelined Processor

* 5-stage pipeline:

  * IF → ID → EX → MEM → WB
* Multiple instructions executed simultaneously
* Improved throughput (≈1 instruction per cycle after fill) 

---

## 🧠 Supported Instructions

| Type   | Instructions              |
| ------ | ------------------------- |
| R-type | `add`, `sub`, `and`, `or` |
| I-type | `addi`, `ld`              |
| S-type | `sd`                      |
| B-type | `beq`                     |

---

## 🏗️ Architecture

### 🔹 Single-Cycle Design

* All operations complete in **one clock cycle**
* Components:

  * Program Counter (PC)
  * Instruction Memory
  * Register File (32 × 64-bit)
  * ALU
  * Data Memory
  * Control Unit 

---

### 🔹 Pipelined Design

#### 📍 Pipeline Stages

1. **IF** – Instruction Fetch
2. **ID** – Decode & Register Read
3. **EX** – ALU Execution
4. **MEM** – Memory Access
5. **WB** – Write Back 

#### 📍 Pipeline Registers

* IF/ID
* ID/EX
* EX/MEM
* MEM/WB

---

## ⚡ Hazard Handling

### 🔸 Data Hazards

* Solved using **Forwarding (Bypassing)**
* Paths:

  * EX/MEM → EX
  * MEM/WB → EX 

---

### 🔸 Load-Use Hazard

* Cannot be solved by forwarding
* Solution: **1-cycle stall (bubble insertion)**

---

### 🔸 Control Hazards

* Occur due to branch instructions
* Solution: **Pipeline flush**
* Branch resolved in EX stage → **2-cycle penalty** 

---

## 🔁 Forwarding Logic (Key Idea)

* Compare:

  * `Rs1E / Rs2E` with `RdM / RdW`
* Prioritize:

  * MEM-stage forwarding over WB-stage
* Avoid forwarding for `x0`

---

## 🧪 Simulation & Verification

* Waveforms used to verify:

  * Pipeline execution
  * Forwarding behavior
  * Load-use stalls
  * Branch flushing

✔ Correct execution achieved using forwarding paths 

---

## 🎯 Key Learnings

* Pipeline improves **throughput, not latency**
* Correct signal propagation across pipeline registers is critical
* Forwarding avoids most stalls but **not all hazards**
* Branch resolution stage directly impacts performance

---

## ⭐ Future Improvements

* Branch prediction
* Cache integration
* Out-of-order execution

* or tailor it specifically for **GitHub portfolio + recruiters** 🔥

