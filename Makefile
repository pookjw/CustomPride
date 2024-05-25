FINALPACKAGE=1
TARGET := iphone:clang:latest:latest
INSTALL_TARGET_PROCESSES = SpringBoard PridePosterExtension PosterBoard
THEOS_PACKAGE_SCHEME = rootless

include $(THEOS)/makefiles/common.mk

SUBPROJECTS += CustomPride_PridePosterExtension

include $(THEOS_MAKE_PATH)/aggregate.mk
