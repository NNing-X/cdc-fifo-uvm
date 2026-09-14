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

## 4. Planned Tests

### Test 1: Reset Test

Apply reset to both clock domains.

Expected behavior:

- `wfull = 0`

- `rempty = 1`

- FIFO starts empty

### Test 2: Single Write / Read

Write one data value and read it back.

Expected behavior:

- Read data matches written data

- FIFO returns to empty after the read

### Test 3: Multiple Write / Read

Write multiple values and then read them back.

Expected behavior:

- All data is returned in FIFO order

### Test 4: FIFO Full

Write entries until the FIFO is full.

Expected behavior:

- `wfull` asserts

- Additional writes do not modify FIFO contents

### Test 5: FIFO Empty

Read all stored entries.

Expected behavior:

- `rempty` asserts after the final entry is read

- Additional reads do not advance the FIFO

### Test 6: Simultaneous Read and Write

Perform reads and writes at the same time.

Expected behavior:

- No data is lost

- FIFO ordering is preserved

### Test 7: Different Clock Rates

Run the FIFO with different write/read clock periods.

Examples:

- Write clock faster than read clock

- Read clock faster than write clock

Expected behavior:

- FIFO continues operating correctly across asynchronous clock domains

### Test 8: Pointer Wrap-Around

Perform enough writes and reads for the FIFO pointers to wrap around.

Expected behavior:

- Data remains correct

- Full and empty detection continues working

---