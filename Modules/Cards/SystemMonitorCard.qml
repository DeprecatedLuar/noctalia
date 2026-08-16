import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.Commons
import qs.Services.System
import qs.Widgets

// Unified system card: monitors CPU, temp, memory, disk
NBox {
  id: root

  property bool pollingActive: false
  property string statsConsumerId: ""
  property bool statsConsumerRegistered: false

  function syncStatsDemand() {
    if (pollingActive && !statsConsumerRegistered) {
      if (!statsConsumerId) {
        Logger.w("SystemMonitorCard", "Cannot register system-stat polling without a consumer ID");
        return;
      }

      SystemStatService.registerConsumer(statsConsumerId, {
                                           "cpuUsage": true,
                                           "cpuTemp": true,
                                           "memory": true,
                                           "disk": true,
                                           "network": false,
                                           "gpuTemp": false
                                         });
      statsConsumerRegistered = true;
    } else if (!pollingActive && statsConsumerRegistered) {
      SystemStatService.unregisterConsumer(statsConsumerId);
      statsConsumerRegistered = false;
    }
  }

  onPollingActiveChanged: syncStatsDemand()
  Component.onCompleted: {
    statsConsumerId = SystemStatService.createConsumerId("control-center-system-monitor");
    syncStatsDemand();
  }
  Component.onDestruction: {
    if (statsConsumerRegistered) {
      SystemStatService.unregisterConsumer(statsConsumerId);
      statsConsumerRegistered = false;
    }
  }

  Item {
    id: content
    anchors.fill: parent
    anchors.margins: Style.marginS

    property int widgetHeight: Math.round(65 * Style.uiScaleRatio)

    ColumnLayout {
      anchors.centerIn: parent
      spacing: 0

      NCircleStat {
        value: SystemStatService.cpuUsage
        icon: "cpu-usage"
        flat: true
        contentScale: 0.8
        height: content.widgetHeight
        Layout.alignment: Qt.AlignHCenter
        // Highlight color based on thresholds
        fillColor: (SystemStatService.cpuUsage > Settings.data.systemMonitor.cpuCriticalThreshold) ? (Settings.data.systemMonitor.useCustomColors ? (Settings.data.systemMonitor.criticalColor || Color.mError) : Color.mError) : (SystemStatService.cpuUsage > Settings.data.systemMonitor.cpuWarningThreshold) ? (Settings.data.systemMonitor.useCustomColors ? (
                                                                                                                                                                                                                                                                                                                                                                    Settings.data.systemMonitor.warningColor
                                                                                                                                                                                                                                                                                                                                                                    || Color.mTertiary) :
                                                                                                                                                                                                                                                                                                                                                                  Color.mTertiary) :
                                                                                                                                                                                                                                                                                                                   Color.mPrimary
        textColor: (SystemStatService.cpuUsage > Settings.data.systemMonitor.cpuCriticalThreshold) ? Color.mSurfaceVariant : (SystemStatService.cpuUsage > Settings.data.systemMonitor.cpuWarningThreshold) ? Color.mSurfaceVariant : Color.mOnSurface
      }
      NCircleStat {
        value: SystemStatService.cpuTemp
        suffix: "°C"
        icon: "cpu-temperature"
        flat: true
        contentScale: 0.8
        height: content.widgetHeight
        Layout.alignment: Qt.AlignHCenter
        // Highlight color based on thresholds
        fillColor: (SystemStatService.cpuTemp > Settings.data.systemMonitor.tempCriticalThreshold) ? (Settings.data.systemMonitor.useCustomColors ? (Settings.data.systemMonitor.criticalColor || Color.mError) : Color.mError) : (SystemStatService.cpuTemp > Settings.data.systemMonitor.tempWarningThreshold) ? (Settings.data.systemMonitor.useCustomColors ? (
                                                                                                                                                                                                                                                                                                                                                                    Settings.data.systemMonitor.warningColor
                                                                                                                                                                                                                                                                                                                                                                    || Color.mTertiary) :
                                                                                                                                                                                                                                                                                                                                                                  Color.mTertiary) :
                                                                                                                                                                                                                                                                                                                   Color.mPrimary
        textColor: (SystemStatService.cpuTemp > Settings.data.systemMonitor.tempCriticalThreshold) ? Color.mSurfaceVariant : (SystemStatService.cpuTemp > Settings.data.systemMonitor.tempWarningThreshold) ? Color.mSurfaceVariant : Color.mOnSurface
      }
      NCircleStat {
        value: SystemStatService.memPercent
        icon: "memory"
        flat: true
        contentScale: 0.8
        height: content.widgetHeight
        Layout.alignment: Qt.AlignHCenter
        // Highlight color based on thresholds
        fillColor: (SystemStatService.memPressurePercent > Settings.data.systemMonitor.memCriticalThreshold) ? (Settings.data.systemMonitor.useCustomColors ? (Settings.data.systemMonitor.criticalColor || Color.mError) : Color.mError) : (SystemStatService.memPressurePercent > Settings.data.systemMonitor.memWarningThreshold) ? (Settings.data.systemMonitor.useCustomColors ? (
                                                                                                                                                                                                                                                                                                                                                                        Settings.data.systemMonitor.warningColor
                                                                                                                                                                                                                                                                                                                                                                        || Color.mTertiary) :
                                                                                                                                                                                                                                                                                                                                                                      Color.mTertiary) :
                                                                                                                                                                                                                                                                                                                       Color.mPrimary
        textColor: (SystemStatService.memPressurePercent > Settings.data.systemMonitor.memCriticalThreshold) ? Color.mSurfaceVariant : (SystemStatService.memPressurePercent > Settings.data.systemMonitor.memWarningThreshold) ? Color.mSurfaceVariant : Color.mOnSurface
      }
      NCircleStat {
        value: SystemStatService.diskPercents["/"] ?? 0
        icon: "storage"
        flat: true
        contentScale: 0.8
        height: content.widgetHeight
        Layout.alignment: Qt.AlignHCenter
        // Highlight color based on thresholds
        fillColor: ((SystemStatService.diskPercents["/"] ?? 0) > Settings.data.systemMonitor.diskCriticalThreshold) ? (Settings.data.systemMonitor.useCustomColors ? (Settings.data.systemMonitor.criticalColor || Color.mError) : Color.mError) : ((SystemStatService.diskPercents["/"] ?? 0) > Settings.data.systemMonitor.diskWarningThreshold) ? (
                                                                                                                                                                                                                                                                                                                                                       Settings.data.systemMonitor.useCustomColors
                                                                                                                                                                                                                                                                                                                                                       ? (Settings.data.systemMonitor.warningColor
                                                                                                                                                                                                                                                                                                                                                          || Color.mTertiary) :
                                                                                                                                                                                                                                                                                                                                                         Color.mTertiary) :
                                                                                                                                                                                                                                                                                                                                                     Color.mPrimary
        textColor: ((SystemStatService.diskPercents["/"] ?? 0) > Settings.data.systemMonitor.diskCriticalThreshold) ? Color.mSurfaceVariant : ((SystemStatService.diskPercents["/"] ?? 0) > Settings.data.systemMonitor.diskWarningThreshold) ? Color.mSurfaceVariant : Color.mOnSurface
      }
    }
  }
}
