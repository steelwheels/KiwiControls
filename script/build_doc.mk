#
# build_doc.mk
#

all:
	(cd KCConsoleView/OSX ; make -f ../Script/generate_doc.mk)
	(cd KCControls/OSX ; make -f ../Script/generate_doc.mk)
	(cd KCGraphics/OSX ; make -f ../Script/generate_doc.mk)
	(cd KCScene/OSX ; make -f ../Script/generate_doc.mk)

