SDKVERSION=4.3

TWEAK_NAME = SwitcherModMini
SwitcherModMini_OBJC_FILES = SwitcherMod.m
SwitcherModMini_FRAMEWORKS = Foundation UIKit QuartzCore CoreGraphics

ADDITIONAL_CFLAGS = -std=c99

include theos/makefiles/common.mk
include theos/makefiles/tweak.mk

