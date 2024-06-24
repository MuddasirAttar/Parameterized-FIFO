Parameterized FIFO Design and Testbench

Overview

This project demonstrates a parameterized FIFO (First In, First Out) design implemented in SystemVerilog. The FIFO can be configured with different data widths and depths. The testbench provided verifies the functionality of the FIFO, ensuring that it correctly handles push and pop operations, and accurately indicates full and empty conditions.

Features

- Parameterized Design**: Easily adjust data width and depth.
- Robust Testbench**: Includes comprehensive tests for full and empty conditions.
- Comprehensive Coverage**: Ensures the FIFO behaves correctly under various scenarios.

Design

The FIFO design includes:
- Logic to manage read and write pointers.
- Handling for FIFO full and empty states.
- Parameterized depth and data width for flexibility.

Testbench

The testbench performs the following:
- Pushes data into the FIFO until it is full.
- Pops data from the FIFO until it is empty.
- Checks and displays the FIFO's full and empty flags to ensure correct operation.

Getting Started

To run the testbench and verify the FIFO design:

1. **Clone the repository**:
   ```bash
   git clone https://github.com/MuddasirAttar/parameterized-FIFO.git
   cd parameterized-FIFO
   ```

2. **Ensure you have a SystemVerilog simulator installed** (e.g., ModelSim, VCS, etc.).

3. Run the simulation**:
   ```bash
   vsim -do "run -all" qs_fifo_tb.sv
   ```

Project Structure

```
.
├── qs_fifo.sv       // FIFO design file
└── qs_fifo_tb.sv    // Testbench file
```

License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.


Contributions are welcome! Please fork the repository and create a pull request with your changes.

For any questions or issues, please open an issue on GitHub.

Feel free to adjust the repository URL and any other details as necessary.
