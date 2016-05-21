#
#
#

SRC_DIR	= ../Document/KiwiControls

all: dummy
	rm -r KCConsoleView KCControls KCGraphics KCScene
	(cd $(SRC_DIR) ; tar cf - KCConsoleView) | tar xfv -
	(cd $(SRC_DIR) ; tar cf - KCControls) | tar xfv -
	(cd $(SRC_DIR) ; tar cf - KCGraphics) | tar xfv -
	(cd $(SRC_DIR) ; tar cf - KCScene) | tar xfv -

dummy:

