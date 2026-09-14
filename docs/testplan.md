# CDC FIFO Verification Test Plan

## 1. Objective

Verify the basic functionality of `socetlib_cdc_fifo` across two asynchronous clock domains.

The main goals are to verify:

- Correct write and read behavior

- FIFO ordering

- Full and empty flag behavior

- Reset behavior

- Correct operation with different write/read clock rates

---

## 2. DUT Configuration

Default configuration:

- `DATA_WIDTH = 4`

- `FIFO_DEPTH = 16`

Additional configurations may be tested later:

- `FIFO_DEPTH = 1`

- Different data widths

- Different FIFO depths

---

## 3. Main Features to Verify

- Write data into FIFO when `winc = 1` and `wfull = 0`

- Read data from FIFO when `rinc = 1` and `rempty = 0`

- Data is read in the same order it was written

- `wfull` asserts when FIFO becomes full

- `rempty` asserts when FIFO becomes empty

- Write pointer does not advance when FIFO is full

- Read pointer does not advance when FIFO is empty

- FIFO operates correctly with asynchronous write and read clocks

- FIFO resets to the expected initial state

---

