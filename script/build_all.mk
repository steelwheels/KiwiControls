#
# Makefile.all
#

IOS_TMP	= tmpi
OSX_TMP	= tmpx

# KiwiControl
all: KCControls KCGraphicsView KCNumberStepper KCPreferenceTable \
     KCSwitch KCTableView KCTextFieldExtension \
     KCTextFieldExtension KCTouchableLabel KCSegmentedController

dummy:

KCControls: dummy
	(cd KCControls/OSX && \
	 make PROJECT_NAME=KCControls \
	      PROJECT_DIR=. \
	      BUILD_DIR=~/build/KCControls.$(OSX_TMP) \
	      BUILD_ROOT=~/build/KCControls.$(OSX_TMP) \
	      -f ../../script/install_osx.mk \
	)

KCGraphicsView: dummy
	(cd KCGraphicsView/iOS && \
	 make PROJECT_NAME=KCGraphicsView \
	      PROJECT_DIR=. \
	      BUILD_DIR=~/build/KCGraphicsView.$(IOS_TMP) \
	      BUILD_ROOT=~/build/KCGraphicsView.$(IOS_TMP) \
	      -f ../../script/install.mk \
	)

KCNumberStepper: dummy
	(cd KCNumberStepper/iOS && \
	 make PROJECT_NAME=KCNumberStepper \
	      PROJECT_DIR=. \
	      BUILD_DIR=~/build/KCNumberStepper.$(IOS_TMP) \
	      BUILD_ROOT=~/build/KCNumberStepper.$(IOS_TMP) \
	      -f ../../script/install.mk \
	)

KCPreferenceTable: dummy
	(cd KCPreferenceTable && \
	 make PROJECT_NAME=KCPreferenceTable \
	      PROJECT_DIR=. \
	      BUILD_DIR=~/build/KCPreferenceTable.$(IOS_TMP) \
	      BUILD_ROOT=~/build/KCPreferenceTable.$(IOS_TMP) \
	      -f ../script/install.mk \
	)

KCSwitch: dummy
	(cd KCSwitch/iOS && \
	 make PROJECT_NAME=KCSwitch \
	      PROJECT_DIR=. \
	      BUILD_DIR=~/build/KCSwitch.$(IOS_TMP) \
	      BUILD_ROOT=~/build/KCSwitch.$(IOS_TMP) \
	      -f ../../script/install.mk \
	)

KCTableView: dummy
	(cd KCTableView/iOS && \
	 make PROJECT_NAME=KCTableView \
	      PROJECT_DIR=. \
	      BUILD_DIR=~/build/KCTableView.$(IOS_TMP) \
	      BUILD_ROOT=~/build/KCTableView.$(IOS_TMP) \
	      -f ../../script/install.mk \
	)

KCTextFieldExtension: dummy
	(cd KCTextFieldExtension && \
	 make PROJECT_NAME=KCTextFieldExtension \
	      PROJECT_DIR=. \
	      BUILD_DIR=~/build/KCTextFieldExtension.$(IOS_TMP) \
	      BUILD_ROOT=~/build/KCTextFieldExtension.$(IOS_TMP) \
	      -f ../script/install.mk \
	)

KCTouchableLabel: dummy
	(cd KCTouchableLabel && \
	 make PROJECT_NAME=KCTouchableLabel \
	      PROJECT_DIR=. \
	      BUILD_DIR=~/build/KCTouchableLabel.$(IOS_TMP) \
	      BUILD_ROOT=~/build/KCTouchableLabel.$(IOS_TMP) \
	      -f ../script/install.mk \
	)

KCSegmentedController: dummy
	(cd KCSegmentedController/iOS && \
	 make PROJECT_NAME=KCSegmentedController \
	      PROJECT_DIR=. \
	      BUILD_DIR=~/build/KCSegmentedController.$(IOS_TMP) \
	      BUILD_ROOT=~/build/KCSegmentedController.$(IOS_TMP) \
	      -f ../../script/install.mk \
	)

