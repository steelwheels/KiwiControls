#
#
#

PROJECT_NAME	= KiwiControls

all:
	(cd OSX && make PROJECT_NAME=$(PROJECT_NAME) -f ../Script/install.mk)
	(cd iOS && make PROJECT_NAME=$(PROJECT_NAME) -f ../Script/install.mk)

