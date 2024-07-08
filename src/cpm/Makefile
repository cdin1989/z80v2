INCDIR:=${ROOT}src\base
OUTDIR:=${ROOT}build\cpm
ROMDIR:=${ROOT}roms\cpm-rom
CPM:=$(OUTDIR)\cpm
IMG:=$(OUTDIR)\8mb-hd.dsk
LOADER:=loader
ZCC:=zcc +z80 -Ca-I$(INCDIR) --no-crt -m
ZASM:=z80asm -I$(INCDIR) -O$(OUTDIR) -b
APPMAKE:=z88dk-appmake

all: $(OUTDIR) $(CPM) $(LOADER) $(IMG)

$(OUTDIR):
	mkdir $@

$(CPM):
	$(ZCC) @cpm.lst -o $@
	$(APPMAKE) +glue -b $@ --ihex --pad --filler 0x00 --clean

$(LOADER):
	$(ZASM) boot.asm
	$(ZASM) loader.asm

$(IMG):
	mkfs.cpm -f z80pack-hd -b $(OUTDIR)\cpm__.bin $@
	cpmcp -f z80pack-hd $(IMG) $(ROMDIR)\ASM.COM 0:ASM.COM
	cpmcp -f z80pack-hd $(IMG) $(ROMDIR)\CLRDIR.COM 0:CLRDIR.COM
	cpmcp -f z80pack-hd $(IMG) $(ROMDIR)\DDT.COM 0:DDT.COM
	cpmcp -f z80pack-hd $(IMG) $(ROMDIR)\DDTZ.COM 0:DDTZ.COM
	cpmcp -f z80pack-hd $(IMG) $(ROMDIR)\DUMP.COM 0:DUMP.COM
	cpmcp -f z80pack-hd $(IMG) $(ROMDIR)\ED.COM 0:ED.COM
	cpmcp -f z80pack-hd $(IMG) $(ROMDIR)\LOAD.COM 0:LOAD.COM
	cpmcp -f z80pack-hd $(IMG) $(ROMDIR)\MBASIC.COM 0:MBASIC.COM
	cpmcp -f z80pack-hd $(IMG) $(ROMDIR)\PIP.COM 0:PIP.COM
	cpmcp -f z80pack-hd $(IMG) $(ROMDIR)\RELOG.COM 0:RELOG.COM
	cpmcp -f z80pack-hd $(IMG) $(ROMDIR)\STAT.COM 0:STAT.COM
	cpmcp -f z80pack-hd $(IMG) $(ROMDIR)\SUBMIT.COM 0:SUBMIT.COM
	cpmcp -f z80pack-hd $(IMG) $(ROMDIR)\XSUB.COM 0:XSUB.COM

	cpmcp -f z80pack-hd $(IMG) $(ROMDIR)\HOCKEY.BAS 0:HOCKEY.BAS
	cpmcp -f z80pack-hd $(IMG) $(ROMDIR)\BLACKJCK.BAS 0:BLACKJCK.BAS
	cpmcp -f z80pack-hd $(IMG) $(ROMDIR)\CIVILWAR.BAS 0:CIVILWAR.BAS


	del /s /q $(OUTDIR)\*.o
	del /s /q $(OUTDIR)\*.ihx
	del /s /q $(OUTDIR)\*.map
	del /s /q $(OUTDIR)\boot.bin
	del /s /q $(OUTDIR)\cpm__.bin

	@echo "+-----------------------+-----------------------+"
	@echo "|1.init program   : loader.bin     -> W27C512   |"
	@echo "|2.cp/m disk image: 8mb-hd.dsk     -> CF Card   |"
	@echo "+-----------------------+-----------------------+"

.PHONY: clean
clean:
	del /s /q $(OUTDIR)\*
	rmdir /s /q $(OUTDIR)
