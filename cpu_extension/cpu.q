/ Get the current frequency of the first cpu in the system.
cpu_frequency:`cpu 2:(`q_get_first_cpu_frequency;1)

/ Read the tsc register of the current processor.
read_cycles:`cpu 2:(`q_read_cycles_of_this_cpu;1)

