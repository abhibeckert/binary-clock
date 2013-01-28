#
# GNUmakefile
#
ifeq ($(GNUSTEP_MAKEFILES),)
 GNUSTEP_MAKEFILES := $(shell gnustep-config --variable=GNUSTEP_MAKEFILES 2>/dev/null)
endif
ifeq ($(GNUSTEP_MAKEFILES),)
 $(error You need to set GNUSTEP_MAKEFILES before compiling!)
endif

include $(GNUSTEP_MAKEFILES)/common.make

#
# Application
#
VERSION = 0.1
PACKAGE_NAME = binary-clock
APP_NAME = binary-clock
binary-clock_APPLICATION_ICON = 


#
# Resource files
#
binary-clock_RESOURCE_FILES = \
Resources/binary-clock.gorm \


#
# Header files
#
binary-clock_HEADER_FILES = \
AppController.h \
desktop/BCAppDelegate.h \
desktop/BCBorderlessWindow.h \
BCBinaryTime.h \
shared/BCClockView.h \
shared/BCClockGlowingSquareView.h 

#
# Class files
#
binary-clock_OBJC_FILES = \
AppController.m \
desktop/BCAppDelegate.m \
desktop/BCBorderlessWindow.m \
BCBinaryTime.m \
shared/BCClockView.m \
shared/BCClockGlowingSquareView.m 

#
# Other sources
#
binary-clock_OBJC_FILES += \
binary-clock_main.m 

#
# Makefiles
#
-include GNUmakefile.preamble
include $(GNUSTEP_MAKEFILES)/aggregate.make
include $(GNUSTEP_MAKEFILES)/application.make
-include GNUmakefile.postamble
