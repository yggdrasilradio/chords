all: chords

chords: chords.bas
	decbpp < chords.bas > redistribute/chords.bas
ifneq ("$(wildcard /media/share1/COCO/drive3.dsk)", "")
	decb copy -tr redistribute/chords.bas /media/share1/COCO/drive3.dsk,CHORDS.BAS
endif
	cat redistribute/chords.bas
