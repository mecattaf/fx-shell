import { Gtk } from "ags/gtk4";
import { createState, onCleanup } from "ags";
import { CenteredDropDown } from "widgets/common/CenteredDropDown";
import {
  OptionSelectProps,
  OptionToggleProps,
  BAR_POSITION_OPTIONS,
  BAR_STYLE_OPTIONS,
  CAVA_STYLE_OPTIONS,
  OS_OPTIONS,
} from "utils/config";
import WidgetManagerPage from "./modules/WidgetManagerPage";
import options from "options.ts";

function OptionSelect({ option, label, choices = [] }: OptionSelectProps) {
  return (
    <box cssClasses={["option-row", "option-select"]}>
      <CenteredDropDown
        options={choices}
        selected={options[option].get()}
        onSelected={(id) => {
          options[option].value = id;
        }}
        cssClasses={["dropdown"]}
      />
      <label
        label={label}
        halign={Gtk.Align.END}
        hexpand={true}
        cssClasses={["option-label"]}
      />
    </box>
  );
}

function OptionToggle({ option, label }: OptionToggleProps) {
  return (
    <box cssClasses={["option-row", "option-toggle"]}>
      <switch
        cssClasses={["option-switch"]}
        active={options[option]}
        onNotifyActive={(self) => {
          console.log(`Toggle ${option} changed to: ${self.active}`);
          options[option].value = self.active;
        }}
      />
      <label
        label={label}
        halign={Gtk.Align.END}
        hexpand
        cssClasses={["option-label"]}
      />
    </box>
  );
}

export default function MatshellSettingsWidget() {
  const [currentPage, setCurrentPage] = createState("bar");

  const pages = [
    { id: "bar", label: "Bar", icon: "Bottom_Navigation" },
    { id: "audio", label: "Audio", icon: "Cadence" },
    { id: "system", label: "System", icon: "Settings_Applications" },
    { id: "widgets", label: "Widgets", icon: "Widgets" },
  ];

  return (
    <box
      class="stacked-settings-widget"
      orientation={Gtk.Orientation.VERTICAL}
      spacing={6}
    >
      {/* Header */}
      <box
        class="settings-header"
        orientation={Gtk.Orientation.HORIZONTAL}
        spacing={6}
      >
        <label label="Matshell Settings" class="header-title" hexpand />
      </box>

      <Gtk.Separator />

      {/* Navigation */}
      <box
        class="settings-nav"
        orientation={Gtk.Orientation.HORIZONTAL}
        homogeneous
        spacing={2}
      >
        {pages.map((page) => (
          <button
            cssClasses={currentPage((current) =>
              current === page.id
                ? ["nav-button", "button"]
                : ["nav-button", "button-disabled"],
            )}
            onClicked={() => {
              setCurrentPage(page.id);
            }}
          >
            <box orientation={Gtk.Orientation.VERTICAL} spacing={2}>
              <label label={page.icon} cssClasses={["nav-icon"]} />
              <label label={page.label} cssClasses={["nav-label"]} />
            </box>
          </button>
        ))}
      </box>

      {/* Scrollable Content Stack */}
      <stack
        cssClasses={["settings-stack"]}
        transitionType={Gtk.StackTransitionType.SLIDE_LEFT_RIGHT}
        transitionDuration={200}
        $={(stack) => {
          const unsubscribe = currentPage.subscribe(() => {
            stack.visibleChildName = currentPage.get();
          });
          onCleanup(unsubscribe);
        }}
      >
        {/* Bar Settings */}
        <box $type="named" name="bar">
          <scrolledwindow
            minContentHeight={140}
            hscrollbarPolicy={Gtk.PolicyType.NEVER}
            vscrollbarPolicy={Gtk.PolicyType.AUTOMATIC}
            cssClasses={["settings-scroll"]}
          >
            <box orientation={Gtk.Orientation.VERTICAL} spacing={5}>
              <OptionSelect
                option="bar.position"
                label="Position"
                choices={BAR_POSITION_OPTIONS}
              />
              <OptionSelect
                option="bar.style"
                label="Style"
                choices={BAR_STYLE_OPTIONS}
              />
              <OptionSelect
                option="bar.modules.os-icon.type"
                label="OS Icon"
                choices={OS_OPTIONS}
              />
              <OptionToggle
                option="bar.modules.clients.enable"
                label="Enable Hypr Clients"
              />
              <OptionToggle
                option="bar.modules.os-icon.enable"
                label="Show OS Icon"
              />
            </box>
          </scrolledwindow>
        </box>

        {/* Audio Settings */}
        <box $type="named" name="audio">
          <scrolledwindow
            minContentHeight={140}
            hscrollbarPolicy={Gtk.PolicyType.NEVER}
            vscrollbarPolicy={Gtk.PolicyType.AUTOMATIC}
            cssClasses={["settings-scroll"]}
          >
            <box orientation={Gtk.Orientation.VERTICAL} spacing={5}>
              <label label="Bar Visualizer" cssClasses={["subsection-title"]} />
              <OptionToggle option="bar.modules.cava.enable" label="Enable" />
              <OptionSelect
                option="bar.modules.cava.style"
                label="Cava Style"
                choices={CAVA_STYLE_OPTIONS}
              />
              <OptionToggle
                option="bar.modules.media.cava.enable"
                label="Enable Cover Cava"
              />
              <Gtk.Separator />
              <label
                label="Music Player Visualizer"
                cssClasses={["subsection-title"]}
              />
              <OptionToggle
                option="music-player.modules.cava.enable"
                label="Enable"
              />
              <OptionSelect
                option="music-player.modules.cava.style"
                label="Style"
                choices={CAVA_STYLE_OPTIONS}
              />
            </box>
          </scrolledwindow>
        </box>

        {/* System Settings */}
        <box
          $type="named"
          name="system"
          orientation={Gtk.Orientation.VERTICAL}
          spacing={5}
        >
          <OptionToggle
            option="system-menu.modules.wifi-advanced.enable"
            label="WiFi Adv. Settings"
          />
          <OptionToggle
            option="system-menu.modules.bluetooth-advanced.enable"
            label="BT Adv. Settings"
          />
        </box>
        <box $type="named" name="widgets">
          <WidgetManagerPage />
        </box>
      </stack>
    </box>
  );
}
