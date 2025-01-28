# Booth's Multiplication Algorithm

## Overview
This project involves designing, implementing, and simulating **Booth's Multiplication Algorithm** using Verilog. The design is structured into two parts:

1. **Booth's Multiplication Implementation:** Implements Booth's multiplication algorithm using digital logic.
2. **Error Correction Using Booth's Logic:** Extends the design to correct errors using Booth's multiplication logic.

This repository contains all necessary Verilog modules, testbenches, and simulation results for understanding and analyzing Booth's algorithm in FPGA-based designs.

---

## Booth's Multiplication Logic
Booth's multiplication algorithm efficiently multiplies signed binary numbers by encoding runs of `1`s in the multiplier to minimize additions/subtractions.

### **Booth's Multiplication Decision Table**

| **Rightmost Bit** | **Value in F1** | **Arithmetic Operation** |
|------------------|---------------|----------------------|
| 0               | 0             | No Operation        |
| 0               | 1             | Addition            |
| 1               | 0             | Subtraction         |
| 1               | 1             | No Operation        |

---

## Main Module: BoothsMultiplierPart1
This is the main module that integrates the Booth's multiplication algorithm with digital logic implementation.

#### **Ports Table**
| **Port Direction** | **Port Name**      | **Active** | **Port Width (bits)** | **Description** |
|--------------------|-------------------|------------|----------------------|----------------|
| **INPUT**         | `CLK`              | Rising     | 1                    | Clock input used for controlling the multiplier |
| **INPUT**         | `CLR`              | High       | 1                    | Clears the multiplier to allow it for later reuse |
| **INPUT**         | `MULTIPLIER`       | -          | 13                   | 13-bit signed decimal input as multiplier |
| **INPUT**         | `MULTIPLICAND`     | -          | 13                   | 13-bit signed decimal input as multiplicand |
| **OUTPUT**        | `RESULT`           | -          | 26                   | 26-bit signed decimal output as a result of multiplication |
| **OUTPUT**        | `OP_DONE`          | -          | 2                    | The operation performed (addition, subtraction, or no-op) |
| **OUTPUT**        | `DONE`             | High       | 1                    | Set high when multiplication is finished |

---

## Embedded Modules

### **Control Unit**
The Control Unit orchestrates the multiplication process by generating necessary control signals.

#### **Ports Table**
| **Port Direction** | **Port Name** | **Active** | **Port Width (bits)** | **Description** |
|--------------------|--------------|------------|----------------------|----------------|
| **INPUT**         | `CLK`         | Rising     | 1                    | Clock input used to control the multiplier |
| **INPUT**         | `RST`         | High       | 1                    | Resets the control unit |
| **OUTPUT**        | `END`         | High       | 1                    | Indicates multiplication is completed |
| **OUTPUT**        | `INIT`        | High       | 1                    | Signal to initialize multiplication |
| **OUTPUT**        | `EX_OP`       | High       | 1                    | Determines whether an operation (Add/Subtract) is needed |
| **OUTPUT**        | `SHIFT`       | High       | 1                    | Determines whether to shift the partial sum |

---

### **Shifter**
This module manages bitwise shifts necessary for the multiplication process.

#### **Ports Table**
| **Port Direction** | **Port Name** | **Active** | **Port Width (bits)** | **Description** |
|--------------------|--------------|------------|----------------------|----------------|
| **INPUT**         | `CLK`         | High       | 1                    | Clock input controlling shifts, clears, and loads |
| **INPUT**         | `CLR`         | High       | 1                    | Resets the shifter |
| **INPUT**         | `LOAD`        | High       | 1                    | Loads data into the shifter |
| **INPUT**         | `SHIFT`       | High       | 1                    | Shifts data right when active |
| **INPUT**         | `DATA_IN`     | -          | 13                   | Input data for loading |
| **INPUT**         | `SHIFT_IN`    | -          | 1                    | Input bit to shift in |
| **OUTPUT**        | `DATA_OUT`    | -          | 13                   | Output stored in the shift register |

---

## Implementation Steps
1. **Understand Booth's algorithm** and its encoding scheme.
2. **Develop the Verilog modules** for Booth's Multiplier, Control Unit, and Shifter.
3. **Write a testbench** to simulate different multiplication cases.
4. **Analyze waveforms** to verify correct operation.

---

## Simulation & Testing

### Steps to Simulate
1. **Clone Repository**
   ```bash
   git clone <repository-url>
   cd booths_multiplier
