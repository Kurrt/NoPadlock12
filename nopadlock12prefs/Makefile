include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = NoPadlock12Prefs
NoPadlock12Prefs_FILES = NPLPRootListController.m
NoPadlock12Prefs_INSTALL_PATH = /Library/PreferenceBundles
NoPadlock12Prefs_FRAMEWORKS = UIKit
NoPadlock12Prefs_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/NoPadlock12Prefs.plist$(ECHO_END)
