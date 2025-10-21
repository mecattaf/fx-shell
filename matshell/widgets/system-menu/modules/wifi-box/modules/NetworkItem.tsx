import Pango from "gi://Pango";
import { Gtk } from "ags/gtk4";
import {
  setSelectedNetwork,
  setShowPasswordDialog,
  setPasswordInput,
  createAccessPointManager,
} from "utils/wifi";

export const NetworkItem = ({ network }) => {
  const apManager = createAccessPointManager(network);

  return (
    <button
      hexpand
      cssClasses={apManager.connectionClasses}
      sensitive={apManager.canConnect}
      onClicked={() => {
        if (!apManager.canConnect.get()) return;

        if (apManager.requiresPasswordDialog()) {
          setSelectedNetwork(network);
          setShowPasswordDialog(true);
          setPasswordInput("");
        } else {
          apManager.connect();
        }
      }}
    >
      <box hexpand>
        <image iconName={apManager.displayInfo((info) => info.iconName)} />
        <label
          label={apManager.displayInfo((info) => info.ssid)}
          maxWidthChars={18}
          ellipsize={Pango.EllipsizeMode.END}
        />
        <box hexpand={true} />

        {/* Status icons */}
        <image
          halign={Gtk.Align.END}
          iconName="network-wireless-encrypted-symbolic"
          visible={apManager.displayInfo((info) => info.secured)}
        />
        <image
          halign={Gtk.Align.END}
          iconName="object-select-symbolic"
          visible={apManager.displayInfo((info) => info.isActive)}
        />
      </box>
    </button>
  );
};
