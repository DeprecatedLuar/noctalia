import QtQuick.Layouts
import Quickshell
import qs.Commons
import qs.Services.Power
import qs.Widgets

NIconButtonHot {
  property ShellScreen screen

  icon: PowerProfileService.noctaliaPerformanceMode ? "rocket" : "rocket-off"
  hot: PowerProfileService.noctaliaPerformanceMode
  tooltipText: PowerProfileService.noctaliaPerformanceMode ? I18n.tr("tooltips.noctalia-performance-enabled") : I18n.tr("tooltips.noctalia-performance-disabled")
  onClicked: PowerProfileService.toggleNoctaliaPerformance()
}
