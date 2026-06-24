# SPI Multi-Slave Communication System in Verilog

![Verilog](https://img.shields.io/badge/Language-Verilog-blue)
![Simulation](https://img.shields.io/badge/Simulation-Icarus%20Verilog-green)
![Waveform](https://img.shields.io/badge/Waveform-GTKWave-orange)
![Synthesis](https://img.shields.io/badge/Synthesis-Yosys-purple)
![Status](https://img.shields.io/badge/Status-Completed-success)

A synthesizable SPI (Serial Peripheral Interface) communication system implemented in Verilog HDL featuring a single SPI master and multiple SPI slaves. The project demonstrates the complete digital design workflow from RTL development and functional verification to synthesis and post-synthesis validation.

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [System Architecture](#system-architecture)
- [Project Structure](#project-structure)
- [Design Flow](#design-flow)
- [SPI Protocol](#spi-protocol)
- [Getting Started](#getting-started)
- [RTL Simulation](#rtl-simulation)
- [Waveform Analysis](#waveform-analysis)
- [Logic Synthesis](#logic-synthesis)
- [Post-Synthesis Verification](#post-synthesis-verification)
- [Example Transactions](#example-transactions)
- [Applications](#applications)
- [Future Improvements](#future-improvements)
- [Contributing](#contributing)
- [Maintainer](#maintainer)

## Overview

This project implements a configurable SPI communication system consisting of:

- One SPI Master Controller
- Four SPI Slave Devices
- Shared SPI communication bus
- Slave-select based communication
- Read and Write transaction support
- Configurable SPI modes (CPOL/CPHA)
- RTL simulation and verification
- Logic synthesis using Yosys
- Post-synthesis gate-level verification

The design provides a practical implementation of the SPI protocol commonly used in microcontrollers, FPGAs, ASICs, sensors, memory devices, and embedded systems.

## Features

### SPI Master

- Generates SPI clock (`SCLK`)
- Controls chip-select signals
- Supports read and write operations
- Serializes parallel data onto MOSI
- Receives serial data from MISO
- Configurable CPOL and CPHA modes
- Read data valid indication

### SPI Slave

- Receives commands from master
- Decodes address and data fields
- Supports read and write transactions
- Tri-state MISO implementation
- Parameterized SPI mode support

### Multi-Slave System

- Four independently addressable slaves
- Shared SPI bus architecture
- Dedicated chip-select generation
- MISO bus multiplexing
- Expandable architecture

### Verification

- Functional RTL simulation
- VCD waveform generation
- GTKWave compatibility
- Post-synthesis verification
- Netlist generation

## System Architecture

```text
                     +----------------+
                     |   SPI Master   |
                     +----------------+
                      |    |    |
                   SCLK MOSI MISO
                      |    |    |
                      +----+----+
                           |
         +-----------------+----------------------------------+
         |                 |               |                  |
         |                 |               |                  |
     +--------+       +--------+       +--------+         +--------+
     |Slave 0 |       |Slave 1 |       |Slave 2 |         |Slave 3 |
     +--------+       +--------+       +--------+         +--------+
         |                |                |                  |
        CS0              CS1              CS2                CS3

                  
                   
                        
                      
```

Only one slave is selected at a time through its chip-select signal while all remaining slaves remain inactive.

## Project Structure

```text
.
├── spi_master.v              # RTL SPI master
├── spi_slave.v               # RTL SPI slave
├── spi_system.v              # Top-level multi-slave SPI system
├── tb_system.v               # Testbench

├── sim                       # RTL simulation executable
├── spi_system.vcd            # RTL simulation waveform

├── synth/
│   ├── synth.ys              # Yosys synthesis script
│   ├── spi_master.v          # RTL copy
│   ├── spi_slave.v           # RTL copy
│   ├── spi_system.v          # RTL copy
│   ├── tb_system.v           # Testbench
│   ├── spi_master_synth.v    # Synthesized SPI master
│   ├── spi_slave_synth.v     # Synthesized SPI slave
│   ├── spi_system_netlist.v  # Synthesized top-level netlist
│   ├── sim                   # Simulation executable
│   ├── post_sim              # Post-synthesis executable
│   └── spi_system.vcd        # Post-synthesis waveform
│
└── README.md
```

## Design Flow

The project follows a standard FPGA/ASIC digital design flow:

```text
RTL Design
    │
    ▼
Functional Simulation
    │
    ▼
Waveform Verification
    │
    ▼
Logic Synthesis (Yosys)
    │
    ▼
Gate-Level Netlist Generation
    │
    ▼
Post-Synthesis Simulation
    │
    ▼
Final Verification
```

This workflow ensures that the synthesized hardware implementation behaves identically to the original RTL description.

## SPI Protocol

### Write Transaction

The master transmits:

```text
[RW][ADDRESS][DATA]
```

Where:

```text
RW      : 1 bit
ADDRESS : 8 bits
DATA    : 8 bits
```

Frame format:

```text
1 | AAAAAAAA | DDDDDDDD
```

Example:

```text
Write 0xAB to Address 0x12

1 | 00010010 | 10101011
```

### Read Transaction

The master transmits:

```text
0 | AAAAAAAA
```

The selected slave responds with:

```text
DDDDDDDD
```

through the MISO line.

## Getting Started

### Prerequisites

Install the required tools:

#### Ubuntu / WSL

```bash
sudo apt update

sudo apt install \
iverilog \
gtkwave \
yosys
```

### Clone Repository

```bash
git clone <repository-url>

cd SPI_MultiSlave
```

## RTL Simulation

Compile the design:

```bash
iverilog -o sim \
spi_master.v \
spi_slave.v \
spi_system.v \
tb_system.v
```

Run simulation:

```bash
vvp sim
```

Expected outputs include:

```text
Write Transaction Completed
Read Transaction Completed
Master Data Received = XX
```

## Waveform Analysis

Open the generated VCD file:

```bash
gtkwave spi_system.vcd
```

Recommended signals:

| Signal | Description |
|----------|------------|
| clk | System clock |
| sclk | SPI clock |
| cs_n | Chip select |
| mosi | Master output |
| miso | Slave output |
| tx_en | Write enable |
| rx_en | Read enable |
| slave_sel | Slave selection |
| address | Address field |
| data_out | Write data |
| data_in | Read data |
| rx_valid | Read data valid |

Observe:

- SPI clock generation
- MOSI serialization
- Slave selection
- MISO response
- Read/write timing
- Data transfer correctness

## Logic Synthesis

The project includes a synthesis script for Yosys.

Run:

```bash
cd synth

yosys synth.ys
```

Generated files:

```text
spi_master_synth.v
spi_slave_synth.v
spi_system_netlist.v
```

These files represent the synthesized gate-level implementation of the design.

## Post-Synthesis Verification

Post-synthesis simulation validates that the synthesized netlist behaves correctly.

Compile:

```bash
iverilog -o post_sim \
spi_system_netlist.v \
tb_system.v
```

Run:

```bash
vvp post_sim
```

Open waveform:

```bash
gtkwave spi_system.vcd
```

This step confirms functional equivalence between RTL and synthesized hardware.

## Example Transactions

### Write to Slave 0

```verilog
slave_sel = 2'b00;
address   = 8'h12;
data_out  = 8'hAB;

tx_en = 1'b1;
#20;
tx_en = 1'b0;
```

### Write to Slave 2

```verilog
slave_sel = 2'b10;
address   = 8'h56;
data_out  = 8'hCD;

tx_en = 1'b1;
#20;
tx_en = 1'b0;
```

### Read from Slave 1

```verilog
slave_sel = 2'b01;
address   = 8'h34;

rx_en = 1'b1;
#20;
rx_en = 1'b0;

wait(rx_valid);
```

## Applications

This project can serve as a reference implementation for:

- FPGA communication systems
- ASIC design projects
- Embedded system interfaces
- Sensor communication networks
- SPI protocol learning
- Digital design coursework
- Verification and synthesis workflows

## Why This Project Is Useful

- Demonstrates a complete SPI implementation.
- Covers both RTL and synthesized design flows.
- Shows practical multi-slave bus communication.
- Provides simulation and verification examples.
- Suitable for FPGA and ASIC learning.
- Useful for academic projects and interviews.
- Easily extensible to larger communication systems.

## Future Improvements

Potential enhancements include:

- FIFO buffering
- Burst mode transfers
- Interrupt support
- Register map implementation
- DMA support
- Variable data widths
- CRC error checking
- AXI/APB wrappers
- FPGA board deployment
- Formal verification

## Contributing

Contributions are welcome.

Possible areas for contribution:

- Additional verification testbenches
- Support for more SPI modes
- Performance optimization
- FPGA implementation examples
- Documentation improvements

Please create an issue or submit a pull request for proposed changes.

## Maintainer

**Puspa Kamal Rai**  
M.Sc. Physics  
Department of Physics  
Sri Sathya Sai Institute of Higher Learning  
Prashanti Nilayam Campus

## Acknowledgements

This project was developed as part of digital system design and communication protocol studies involving:

- Verilog HDL
- SPI Communication Protocol
- RTL Design Methodology
- Functional Verification
- Logic Synthesis using Yosys
- Digital Hardware Development Flow

---

**Language:** Verilog HDL  
**Simulation:** Icarus Verilog + GTKWave  
**Synthesis:** Yosys  
**Design Type:** SPI Multi-Slave Communication System  
**Target:** FPGA / ASIC Digital Design
