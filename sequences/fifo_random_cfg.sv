
class fifo_random_cfg extends uvm_object;

    `uvm_object_utils(fifo_random_cfg)

    rand int unsigned operation;
    rand int unsigned write_burst;
    rand int unsigned read_burst;
    rand int unsigned idle_cycles;

    int unsigned occupancy;

    constraint operation_c {
        operation inside {[0:2]};

        if (occupancy == 0)
            operation != 1;

        if (occupancy == FIFO_DEPTH)
            operation == 1;

        operation dist {
            0 := 35,
            1 := 35,
            2 := 30
        };
    }

    constraint burst_c {
        if (operation == 0) {
            write_burst inside {[1:FIFO_DEPTH-occupancy]};
            read_burst == 0;
        }

        if (operation == 1) {
            write_burst == 0;
            read_burst inside {[1:occupancy]};
        }

        if (operation == 2) {
            write_burst inside {[1:FIFO_DEPTH-occupancy]};
            read_burst inside {[1:occupancy+write_burst]};
        }
    }

    constraint idle_c {
        idle_cycles inside {[0:3]};
    }

    function new(string name = "fifo_random_cfg");
        super.new(name);
    endfunction

endclass
