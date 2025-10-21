import app from "ags/gtk4/app";
import { Astal, Gtk } from "ags/gtk4";
import Mpris from "gi://AstalMpris";
import { createBinding, createState, With, onCleanup } from "ags";
import Gio from "gi://Gio?version=2.0";
import { findPlayer, generateBackground } from "utils/mpris";
import { Cover } from "./modules/Cover";
import { Info } from "./modules/Info";
import { CavaDraw } from "./modules/cava";
import options from "options.ts";
import { gdkmonitor } from "utils/monitors";

function MusicBox({ player }: { player: Mpris.Player }) {
  const [blurredCover, setBlurredCover] = createState(player.cover_art || "");
  let measureBox: Gtk.Box | null = null;

  const coverBinding = createBinding(player, "cover_art");
  const unsubscribe = coverBinding.subscribe(() => {
    const coverArt = player.cover_art;
    if (coverArt) {
      generateBackground(coverArt).then(setBlurredCover);
    }
  });

  onCleanup(() => {
    unsubscribe();
  });

  // initial blur
  if (player.cover_art) {
    generateBackground(player.cover_art).then(setBlurredCover);
  }

  return (
    <overlay
      $={(self) => {
        if (measureBox) {
          self.set_measure_overlay(measureBox, true);
        }
      }}
    >
      <Gtk.ScrolledWindow $type="overlay">
        <Gtk.Picture
          cssClasses={["blurred-cover"]}
          file={blurredCover((path) => Gio.file_new_for_path(path))}
          contentFit={Gtk.ContentFit.COVER}
        />
      </Gtk.ScrolledWindow>
      <box
        cssClasses={["cava-container"]}
        $type="overlay"
        canTarget={false}
        visible={options["music-player.modules.cava.enable"]}
      >
        <CavaDraw
          hexpand
          vexpand
          style={options["music-player.modules.cava.style"]}
        />
      </box>
      <box
        $type="overlay"
        $={(self) => {
          measureBox = self;
        }}
      >
        <Cover player={player} />
        <Info player={player} />
      </box>
    </overlay>
  );
}

export default function MusicPlayer() {
  const mpris = Mpris.get_default();
  const { TOP, BOTTOM } = Astal.WindowAnchor;
  const [visible, _setVisible] = createState(false);

  const topMargin = options["bar.position"]((pos) => {
    if (pos === "top") {
      return 45;
    }
    return 0;
  });

  const bottomMargin = options["bar.position"]((pos) => {
    if (pos === "bottom") {
      return 45;
    }
    return 0;
  });

  return (
    <window
      name="music-player"
      cssClasses={["music", "window"]}
      application={app}
      layer={Astal.Layer.OVERLAY}
      exclusivity={Astal.Exclusivity.IGNORE}
      anchor={options["bar.position"]((pos) => {
        switch (pos) {
          case "top":
            return TOP;
          case "bottom":
            return BOTTOM;
          default:
            return TOP;
        }
      })}
      keymode={Astal.Keymode.ON_DEMAND}
      visible={visible}
      gdkmonitor={gdkmonitor}
      marginTop={topMargin}
      marginBottom={bottomMargin}
    >
      <box>
        <With value={createBinding(mpris, "players")}>
          {(players: Mpris.Player[]) =>
            players.length > 0 ? (
              <MusicBox player={findPlayer(players)} />
            ) : null
          }
        </With>
      </box>
    </window>
  );
}
