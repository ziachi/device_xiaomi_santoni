#
# Copyright (C) 2017-2021 The LineageOS Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

LOCAL_PATH := $(call my-dir)

ifneq ($(filter santoni,$(TARGET_DEVICE)),)

include $(call all-makefiles-under,$(LOCAL_PATH))

include $(CLEAR_VARS)

# A/B builds require us to create the mount points at compile time.
# Just creating it for all cases since it does not hurt.
FIRMWARE_MOUNT_POINT := $(TARGET_OUT_VENDOR)/firmware_mnt
DSP_MOUNT_POINT := $(TARGET_OUT_VENDOR)/dsp
$(FIRMWARE_MOUNT_POINT):
	@echo "Creating $(FIRMWARE_MOUNT_POINT)"
	@mkdir -p $(TARGET_OUT_VENDOR)/firmware_mnt

$(DSP_MOUNT_POINT):
	@echo "Creating $(DSP_MOUNT_POINT)"
	@mkdir -p $(TARGET_OUT_VENDOR)/dsp

ALL_DEFAULT_INSTALLED_MODULES += $(FIRMWARE_MOUNT_POINT) $(DSP_MOUNT_POINT) $(PERSIST_MOUNT_POINT)

endif

# V12: Override bloat apps for 2GB RAM optimization

include $(CLEAR_VARS)
LOCAL_MODULE := GameSpace_disable
LOCAL_OVERRIDES_PACKAGES := GameSpace
include $(BUILD_PHONY_PACKAGE)

include $(CLEAR_VARS)
LOCAL_MODULE := LMOFreeform_disable
LOCAL_OVERRIDES_PACKAGES := LMOFreeform
include $(BUILD_PHONY_PACKAGE)

include $(CLEAR_VARS)
LOCAL_MODULE := LMOFreeformSidebar_disable
LOCAL_OVERRIDES_PACKAGES := LMOFreeformSidebar
include $(BUILD_PHONY_PACKAGE)

include $(CLEAR_VARS)
LOCAL_MODULE := OmniJaws_disable
LOCAL_OVERRIDES_PACKAGES := OmniJaws
include $(BUILD_PHONY_PACKAGE)

include $(CLEAR_VARS)
LOCAL_MODULE := OmniStyle_disable
LOCAL_OVERRIDES_PACKAGES := OmniStyle
include $(BUILD_PHONY_PACKAGE)

include $(CLEAR_VARS)
LOCAL_MODULE := Seedvault_disable
LOCAL_OVERRIDES_PACKAGES := Seedvault
include $(BUILD_PHONY_PACKAGE)

include $(CLEAR_VARS)
LOCAL_MODULE := DeviceDiagnostics_disable
LOCAL_OVERRIDES_PACKAGES := DeviceDiagnostics
include $(BUILD_PHONY_PACKAGE)

include $(CLEAR_VARS)
LOCAL_MODULE := LiveWallpapersPicker_disable
LOCAL_OVERRIDES_PACKAGES := LiveWallpapersPicker
include $(BUILD_PHONY_PACKAGE)

include $(CLEAR_VARS)
LOCAL_MODULE := WallpaperBackup_disable
LOCAL_OVERRIDES_PACKAGES := WallpaperBackup
include $(BUILD_PHONY_PACKAGE)

include $(CLEAR_VARS)
LOCAL_MODULE := ColumbusService_disable
LOCAL_OVERRIDES_PACKAGES := ColumbusService
include $(BUILD_PHONY_PACKAGE)

include $(CLEAR_VARS)
LOCAL_MODULE := BatteryStatsViewer_disable
LOCAL_OVERRIDES_PACKAGES := BatteryStatsViewer
include $(BUILD_PHONY_PACKAGE)

include $(CLEAR_VARS)
LOCAL_MODULE := LineageSetupWizard_disable
LOCAL_OVERRIDES_PACKAGES := LineageSetupWizard
include $(BUILD_PHONY_PACKAGE)

include $(CLEAR_VARS)
LOCAL_MODULE := AvatarPicker_disable
LOCAL_OVERRIDES_PACKAGES := AvatarPicker
include $(BUILD_PHONY_PACKAGE)

include $(CLEAR_VARS)
LOCAL_MODULE := Backgrounds_disable
LOCAL_OVERRIDES_PACKAGES := Backgrounds
include $(BUILD_PHONY_PACKAGE)

include $(CLEAR_VARS)
LOCAL_MODULE := Twelve_disable
LOCAL_OVERRIDES_PACKAGES := Twelve
include $(BUILD_PHONY_PACKAGE)

include $(CLEAR_VARS)
LOCAL_MODULE := MatLog_disable
LOCAL_OVERRIDES_PACKAGES := MatLog
include $(BUILD_PHONY_PACKAGE)

include $(CLEAR_VARS)
LOCAL_MODULE := EasterEgg_disable
LOCAL_OVERRIDES_PACKAGES := EasterEgg
include $(BUILD_PHONY_PACKAGE)

include $(CLEAR_VARS)
LOCAL_MODULE := ThemePicker_disable
LOCAL_OVERRIDES_PACKAGES := ThemePicker
include $(BUILD_PHONY_PACKAGE)

include $(CLEAR_VARS)
LOCAL_MODULE := ThemesStub_disable
LOCAL_OVERRIDES_PACKAGES := ThemesStub
include $(BUILD_PHONY_PACKAGE)
