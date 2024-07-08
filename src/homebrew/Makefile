OUTDIR:=${ROOT}build\homebrew
APP:=$(OUTDIR)\rom
ZCC:=zcc +z80 -vn -clib=new -O3 -lm

all: $(OUTDIR) $(APP)

$(OUTDIR):
	mkdir $@

$(APP):
	$(ZCC) @src.lst -o $@ -create-app -pragma-include:pragma.inc

.PHONY: clean
clean:
	del /s /q $(OUTDIR)\*
	rmdir /s /q $(OUTDIR)
