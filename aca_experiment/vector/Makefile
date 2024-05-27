include ../utils/rt_vector.mk

BUILDDIR = $(CURDIR)/build

clean:
	rm -f *.o $(BUILDDIR)/test
	make -C .. TARGETS=vector_system MODULES=$(CURDIR) clean

all:
	mkdir -p $(BUILDDIR)
	#riscv32-unknown-elf-gcc -g -o $(BUILDDIR)/test vector_klad.s $(RT_SRCS) $(RT_FLAGS)
	riscv32-unknown-elf-gcc -g -o $(BUILDDIR)/test vector_fmeanr.s $(RT_SRCS) $(RT_FLAGS)
	#riscv32-unknown-elf-gcc -S $(BUILDDIR)/test fill_mem.c $(RT_SRCS) $(RT_FLAGS)

gvsoc:
	make -C ../.. TARGETS=vector_system MODULES=$(CURDIR) build

run:
	../../install/bin/gvsoc --target-dir=$(CURDIR) --target=vector_system --work-dir=$(BUILDDIR) --binary=$(BUILDDIR)/test run $(runner_args)