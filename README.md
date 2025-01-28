# Booth's Multiplication Algorithm & Error Correction

## Overview
This project involves designing, implementing, and simulating an **Error Correction Algorith** by leveraging the efficiency of Booth's Logic using **Verilog**. The design is structured into two parts:

1. **Booth's Multiplication Implementation:** Implements Booth's multiplication algorithm using digital logic.
2. **Error Correction Using Booth's Logic:** Extends the design to correct errors in 12-bit code-words using Booth's multiplication logic.

---

## Part 1

## Booth's Multiplication Algorithm
Booth's multiplication algorithm efficiently multiplies signed binary numbers by encoding runs of `1`s in the multiplier to minimize additions/subtractions.

### **Booth's Multiplication Decision Table**

| **Rightmost Bit** | **Value in F1** | **Arithmetic Operation** |
|------------------|---------------|----------------------|
| 0               | 0             | No Operation        |
| 0               | 1             | Addition            |
| 1               | 0             | Subtraction         |
| 1               | 1             | No Operation        |

---

## BoothsMultiplier
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

## Part 2

## Error Correction using Booth's

### **Key Concepts from Error Correction Theory**
- **Error Injection:** Errors are artificially introduced in the system to test detection and correction capabilities.
- **Three-Phase Correction Algorithm:** The process involves identifying, flagging, and rectifying errors based on encoded patterns.
- **Invariant Properties:** The system follows specific rules (invariants) to determine if an error exists and how it should be corrected.

---
## Error Correction Codewords
The system identifies and corrects errors in **signed binary codewords** used in multiplication.

| **Positive Number** | **Codeword**     | **Negative Number** | **Codeword**     |
|--------------------|----------------|--------------------|----------------|
| 0                 | 010110011010    | -1                 | 101001100101    |
| 1                 | 001110011100    | -2                 | 110001100011    |
| 2                 | 001101101100    | -3                 | 110010010011    |
| 3                 | 001011110100    | -4                 | 110100001011    |
| 4                 | 000111111000    | -5                 | 111000001111    |

---

## What Are Invariants?
**Invariants** are rules that remain unchanged throughout the error detection process. These invariants help in identifying incorrect patterns and guide the correction process. The two primary invariants used are:

1. **Invariant #1:** Total number of 1’s: each codeword consists of exactly six 0’s and six 1’s. This invariant alone provides a single error detection capability
2. **Invariant #2:** Sum of indices: if we assign an index of 1 to 12 to each bit (from least significant bit to most significant) and perform a summation of all the indices where a 1 appears and subtract the indices where a 0 appears, we get a sum of 0.

### **How Are Invariants Calculated?**
Invariants are calculated using Booth's encoding properties:
- **Invariant #1:**
  - The system evaluates two consecutive bits (`CᵢCᵢ₋₁`) to decide whether to add or subtract an index value `i`.
- **Invariant #2:**
  - The system checks the value of `Cᵢ` to determine the appropriate correction operation.

These calculations ensure that the error correction follows a systematic and reliable approach.

---

## Error Detection & Correction Invariant Operations
These **invariants** help identify incorrect patterns in the encoded binary representation and dictate how the correction is applied.

### **Invariant #1 Operations**
| **CiCi-1** | **Operation**       |
|-----------|------------------|
| 00        | -                |
| 01        | Add Index *i*    |
| 10        | Subtract Index *i* |
| 11        | -                |

### **Degraded Invariant #2 Operations**
| **CiCi-1** | **Operation**       |
|-----------|------------------|
| 00        | Subtract Index *i* |
| 01        | -                |
| 10        | -                |
| 11        | Add Index *i*    |

---
---

## Three-Phase Error Correction Algorithm
The error correction mechanism is divided into three key phases:

### **Phase 1: Calculate the Number of 1’s**
1. Clear accumulator `A`, load the codeword to be inspected into the multiplier, initialize the counter to 1, reset flip-flop `F` to 0.
2. Repeat 13 times:
   - If the rightmost bit of the multiplier is 1 and `F = 0`, `A = A - counter`.
   - If the rightmost bit of the multiplier is 0 and `F = 1`, `A = A + counter`.
   - Otherwise, discard the result of the adder/subtractor (not saved in accumulator `A`).
   - Shift the multiplier to the right (the rightmost bit of the multiplier is shifted into `F`), increment the counter by 1.
3. Perform error detection on `A`.

### **Phase 2: Calculate the Sum of Indices**
1. Load the value 7 into accumulator `A`, load the codeword into the multiplier, initialize the counter to 1, reset flip-flop `F` to 0.
2. Repeat 13 times:
   - If the rightmost bit of the multiplier is 0 and `F = 0`, `A = A - counter`.
   - If the rightmost bit of the multiplier is 1 and `F = 1`, `A = A + counter`.
   - Otherwise, discard the result of the adder/subtractor.
   - Shift the multiplier to the right, increment the counter by 1.
3. Perform error detection on `A`, identify the corrupted bit, and display the corrected word.

### **Phase 3: Embedded Value Calculation**
1. Load the value 3 into accumulator `A`, load the least significant 6 bits of the codeword into the multiplier (bits 7 through D of the codeword are set to 0 to provide the appropriate dummy bit at position 7).
2. Initialize the counter to 1, reset flip-flop `F` to 0.
3. Repeat 7 times:
   - If the rightmost bit of the multiplier is 0 and `F = 0`, `A = A - counter`.
   - If the rightmost bit of the multiplier is 1 and `F = 1`, `A = A + counter`.
   - Otherwise, discard the result of the adder/subtractor.
   - Shift the multiplier to the right, increment the counter by 1.
4. Store the accumulator value immediately into a register after the 7th step.
5. Compute the embedded value using the stored accumulator value.

---
