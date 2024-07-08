OUTDIR:=${ROOT}build\benchmark
ZASM:=z80asm -O$(OUTDIR) -b

all: benchmark_digital_io\
	 benchmark_vdp\
	 benchmark_joypad\
	 benchmark_psg\
	 benchmark_kbc\
	 benchmark_sio

benchmark_digital_io:
	$(ZASM) $@

benchmark_joypad:
	$(ZASM) $@

benchmark_vdp:
	$(ZASM) $@

benchmark_psg:
	$(ZASM) $@

benchmark_kbc:
	$(ZASM) $@

benchmark_sio:
	$(ZASM) $@

.PHONY: clean
clean:
	del /s /q $(OUTDIR)\*
	rmdir /s /q $(OUTDIR)