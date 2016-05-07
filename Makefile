#
#
#

SRC_DIR	= ../Document/KiwiControls

all: KCGraphics

KCGraphics: dummy
	(cd $(SRC_DIR) ; tar cf - KCGraphics) | tar xfv -

dummy:

