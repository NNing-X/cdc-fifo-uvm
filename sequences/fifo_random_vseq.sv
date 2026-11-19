
class fifo_random_vseq extends uvm_sequence;

    `uvm_object_utils(fifo_random_vseq)

    uvm_sequencer_base w_sequencer;
    uvm_sequencer_base r_sequencer;

    rand int unsigned write_burst;
    rand int unsigned read_burst;
    rand int unsigned idle_cycles;

    int num_iterations = 10;
    int unsigned total_writes = 0;
    int unsigned total_reads = 0;

    constraint burst_c {
        write_burst inside {[1:8]};
        read_burst inside {[1:8]};
    }

    constraint idle_c {
        idle_cycles inside {[0:3]};
    }

    function new(string name = "fifo_random_vseq");
        super.new(name);
    endfunction

    task body();

        write_sequence wseq;
        read_sequence rseq;
        write_sequence prefill_seq;
        read_sequence drain_seq;

        int unsigned remaining;

        if (w_sequencer == null || r_sequencer == null)
            `uvm_fatal("NO_SEQR", "Virtual sequence sequencers not assigned")

        for (int i = 0; i < num_iterations; i++) begin

            if (!randomize())
                `uvm_fatal("RAND_FAIL", "Virtual sequence randomization failed")

            `uvm_info(
                "RANDOM_VSEQ",
                $sformatf(
                    "Iteration=%0d write_burst=%0d read_burst=%0d idle=%0d",
                    i, write_burst, read_burst, idle_cycles
                ),
                UVM_LOW
            )

            prefill_seq = write_sequence::type_id::create("prefill_seq");
            prefill_seq.num_writes = 8;
            prefill_seq.start(w_sequencer);

            total_writes += 8;

            repeat (idle_cycles) #10;

            wseq = write_sequence::type_id::create("wseq");
            rseq = read_sequence::type_id::create("rseq");

            wseq.num_writes = write_burst;
            rseq.num_reads = read_burst;

            fork
                wseq.start(w_sequencer);
                rseq.start(r_sequencer);
            join

            total_writes += write_burst;
            total_reads += read_burst;

            remaining = 8 + write_burst - read_burst;

            drain_seq = read_sequence::type_id::create("drain_seq");
            drain_seq.num_reads = remaining;
            drain_seq.start(r_sequencer);

            total_reads += remaining;

        end

    endtask

endclass
