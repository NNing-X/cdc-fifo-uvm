package cdc_fifo_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    // Shared parameters
    parameter int DATA_WIDTH = 4;
    parameter int FIFO_DEPTH = 16;

    // Transactions
    `include "write/write_transaction.sv"
    `include "read/read_transaction.sv"

    // Sequencers
    `include "write/write_sequencer.sv"
    `include "read/read_sequencer.sv"

    // Drivers
    `include "write/write_driver.sv"
    `include "read/read_driver.sv"

    // Monitors
    `include "write/write_monitor.sv"
    `include "read/read_monitor.sv"

    // Agents
    `include "write/write_agent.sv"
    `include "read/read_agent.sv"

    // Scoreboard
    `include "cdc_fifo_scoreboard.sv"

    // Environment
    `include "cdc_fifo_env.sv"

    // Sequences
    `include "../sequences/write_sequence.sv"
    `include "../sequences/read_sequence.sv"

    // Tests
    `include "../tests/base_test.sv"
    `include "../tests/reset_test.sv"

endpackage