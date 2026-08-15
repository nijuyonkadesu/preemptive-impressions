# Disabling some builtin application through ADB

1. enable wireless debugging from developer settings
2. install platform tools and run (using IP & port): `adb pair 100.xx.xxx.70:xxxxx`
3. run the script

```sh
adb shell pm uninstall -k --user 0 com.android.hotwordenrollment.okgoogle
adb shell pm uninstall -k --user 0 com.android.hotwordenrollment.xgoogle

adb shell pm uninstall -k --user 0 com.coloros.assistantscreen
adb shell pm uninstall -k --user 0 com.coloros.childrenspace
adb shell pm uninstall -k --user 0 com.coloros.floatassistant
adb shell pm uninstall -k --user 0 com.coloros.operationManual
adb shell pm uninstall -k --user 0 com.coloros.scenemode
adb shell pm uninstall -k --user 0 com.coloros.smartsidebar

adb shell pm uninstall -k --user 0 com.google.android.accessibility.switchaccess
adb shell pm uninstall -k --user 0 com.google.android.feedback
adb shell pm uninstall -k --user 0 com.google.android.marvin.talkback
adb shell pm uninstall -k --user 0 com.google.android.odad
adb shell pm uninstall -k --user 0 com.google.android.ondevicepersonalization.services
adb shell pm uninstall -k --user 0 com.google.mainline.adservices
adb shell pm uninstall -k --user 0 com.google.android.adservices.api

adb shell pm uninstall -k --user 0 com.microsoft.appmanager
adb shell pm uninstall -k --user 0 com.microsoft.deviceintegrationservice
adb shell pm uninstall -k --user 0 com.microsoftsdk.crossdeviceservicebroker

adb shell pm uninstall -k --user 0 com.oneplus.membership

adb shell pm uninstall -k --user 0 com.oplus.dmp
adb shell pm uninstall -k --user 0 com.oplus.eid

adb shell pm uninstall -k --user 0 com.oplus.obrain
adb shell pm uninstall -k --user 0 com.oplus.qualityprotect

adb shell pm uninstall -k --user 0 com.oplus.sauhelper
adb shell pm uninstall -k --user 0 com.oplus.securitykeyboard
adb shell pm uninstall -k --user 0 com.oplus.statistics.rom
adb shell pm uninstall -k --user 0 com.oppo.quicksearchbox

adb shell pm uninstall -k --user 0 com.qualcomm.qti.devicestatisticsservice
```
