OUTDIR:=${ROOT}build\gal22v10
CUPL:=cupl -jaxfl

all: $(OUTDIR)\
	z80_memory\
	z80_digital_io\
	z80_vdp\
	z80_joypad_psg\
	z80_kbc\
	z80_sio\
	z80_flash
	
$(OUTDIR):
	mkdir $@
	xcopy /y *.pld $(OUTDIR)

z80_memory:
	$(CUPL) $(OUTDIR)\$@

z80_digital_io:
	$(CUPL) $(OUTDIR)\$@

z80_vdp:
	$(CUPL) $(OUTDIR)\$@

z80_joypad_psg:
	$(CUPL) $(OUTDIR)\$@

z80_kbc:
	$(CUPL) $(OUTDIR)\$@

z80_sio:
	$(CUPL) $(OUTDIR)\$@

z80_flash:
	$(CUPL) $(OUTDIR)\$@

.PHONY: clean
clean:
	del /s /q $(OUTDIR)\*
	rmdir /s /q $(OUTDIR)