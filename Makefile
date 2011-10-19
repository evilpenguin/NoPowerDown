export THEOS_DEVICE_IP = localhost
export THEOS_DEVICE_PORT = 2222

include theos/makefiles/common.mk
TWEAK_NAME = NoPowerDown
NoPowerDown_FILES = Tweak.xm PowerDownAlertView.mm
NoPowerDown_FRAMEWORKS = UIKit
include $(THEOS_MAKE_PATH)/tweak.mk
