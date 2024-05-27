include ../utils/rt.mk

BUILDDIR = $(CURDIR)/build

clean:
	rm -f *.o $(BUILDDIR)/test
	make -C .. TARGETS=scalar_system MODULES=$(CURDIR) clean

all:
	mkdir -p $(BUILDDIR)
	riscv32-unknown-elf-gcc -g -o $(BUILDDIR)/test vector_stuff.s $(RT_SRCS) $(RT_FLAGS)
	#riscv64-unknown-elf-gcc -g -o $(BUILDDIR)/test main.c $(RT_SRCS) $(RT_FLAGS)
	#riscv64-unknown-elf-gcc -g -o $(BUILDDIR)/test fmeanr.c $(RT_SRCS) $(RT_FLAGS)
	#riscv64-unknown-elf-gcc -S $(BUILDDIR)/test fmeanr.c $(RT_SRCS) $(RT_FLAGS)

gvsoc:
	make -C ../.. TARGETS=aca_system MODULES=$(CURDIR) build

run:
	../../install/bin/gvsoc --target-dir=$(CURDIR) --target=aca_system --work-dir=$(BUILDDIR) --binary=$(BUILDDIR)/test run $(runner_args)