<div align="center">

# Matshell

### A GTK4 Material Design desktop shell powered by [AGS](https://github.com/Aylur/ags), [Astal](https://github.com/Aylur/astal), [Gnim](https://github.com/aylur/gnim), and [Matugen](https://github.com/InioX/matugen)

![GitHub repo size](https://img.shields.io/github/repo-size/neurarian/matshell?style=for-the-badge&logo=gitlfs&logoColor=%23FFDBC9&labelColor=%2346362d&color=%23FFDBC9)
![GitHub commit activity](https://img.shields.io/github/commit-activity/m/neurarian/matshell?style=for-the-badge&logo=git&logoColor=%23FFB68D&labelColor=%2346362d&color=%23FFB68D)
![GitHub last commit (branch)](https://img.shields.io/github/last-commit/neurarian/matshell/master?style=for-the-badge&logo=git&logoColor=%23EDBD92&labelColor=%2346362d&color=%23EDBD92)
![GitHub Repo stars](https://img.shields.io/github/stars/neurarian/matshell?style=for-the-badge&logo=github&logoColor=%23ECBF78&labelColor=%2346362d&color=%23ECBF78)

![Neurarian_Matshell_round-2](https://github.com/user-attachments/assets/f3a2cbf8-6f62-4047-938f-68a4a01d8cd3)

______________________________________________________________________

<img width="1921" height="1081" alt="2025-10-08T22:57:51,980193463+02:00" src="https://github.com/user-attachments/assets/f0b2c99f-9d15-4a86-8625-3b1d6bf3c6ce" />

______________________________________________________________________

</div>

Matshell is a GPU-accelerated Material Design inspired desktop shell built with [AGS/Astal](https://github.com/Aylur/astal) for [Hyprland](https://github.com/hyprwm/Hyprland) and [River](https://codeberg.org/river/river). This project draws heavy inspiration from [fufexan's](https://github.com/fufexan/dotfiles) AGSv1 config, with design influences from [saimoomedits](https://github.com/saimoomedits/eww-widgets), tailored for both multi-monitor desktop setups and laptops.

This setup tries to achieve sleek, "MacOS-esque" looks with a little bit of rice sprinkled on top.

***Now using AGSv3.***

## ✨ Features

- **Adaptive Layout**: Automatically adapts to desktop or laptop environments by conditionally rendering notebook-specific widgets
- **Dynamic Material Design Theming**: Change themes on-the-fly via [matugen](https://github.com/InioX/matugen) templates
- **Multi-monitor Support**: Designed with multi-monitor setups in mind
- **Hyprland & River Support**: Automatic compositor detection
- **Cava Visualizer Library**: Ships with an extensive lib of optional Cava visualizers to enjoy your music to
- **Multimodal Fuzzy & Frecency Picker**: Apps, clipboard, wallpapers - all ranked by frequency + recency, loosely based on [gnofi](https://github.com/Aylur/gnofi).
- **Nix Support**: Support for NixOS / Home-Manager with dedicated module
- **Configurable**: Includes option menu to hot-reload styles and components

<details>
  <summary>Show detailed components list</summary>

### ⚙️ Components

- 📌 Status Bar - Sleek, informative main bar with system information

  - Workspace Management - Themed Hyprland or River workspace integration
  - System Tray
  - Visual Performance Monitoring - CPU & memory
  - Simple Clock

- 🎧 Music Player - Media controls, music cover themed

  - Audio Visualization - Extensive library of CAVA visualizer styles to choose from

- 🔧 System Menu - Minimalistic core system integration

  - Network Management - WiFi scanning, connection management, and status monitoring
  - Bluetooth Support - Device pairing, management, and status indicators
  - Brightness Controls
  - Audio Controls
  - Battery Metrics
  - Power Profiles
  - Notification Center - Intuitive notification management system & DND mode

- 💤 Logout Menu - wlogout-like but ags

- 🎯 Multimodal Launcher - Fast fuzzy search application access and frecency default items

- 💻 On-Screen Display - Tracks Audio, Brightness, and Bluetooth connections

</details>

## ⛓️ Dependencies

<details>
  <summary>Show dependency list</summary>

#### Required:

- aylurs-gtk-shell-git
- libastal-hyprland-git **or** libastal-river-git
- libastal-tray-git
- libastal-notifd-git
- libastal-apps-git
- libastal-wireplumber-git
- libastal-mpris-git
- libastal-network-git
- libastal-bluetooth-git
- libastal-cava-git
- libastal-battery-git
- libastal-powerprofiles-git
- libgtop
- libadwaita
- libsoup3
- glib-networking
- hyprland **or** river
- wl-clipboard
- cliphist
- coreutils
- dart-sass
- imagemagick
- networkmanager
- wireplumber
- bluez & bluez-utils (will also run fine without, but throws some non-critical errors on startup)
- adwaita-icon-theme
- ttf-material-symbols-variable-git
- ttf-firacode-nerd
- ***For matugen theming:***
  - matugen
  - swww **or** hyprpaper
  - [image-hct](https://github.com/Neurarian/image-hct) (optional; for proper chroma/tone based theming. Uses imagemagick as fallback)

#### Not required but useful for laptop device features:

- upower
- brightnessctl

</details>

## 🛠️ Installation

> [!NOTE]
> If you're using an old version of matshell and want to update or you're using your own setup, you will need to move your old config out of ~/.config/ags/ or delete the folder before running the script, as I am not overwriting existing configs.
> If the Arch install below is broken please open an issue as I don't run Arch and only test this in a VM from time to time.

Run the installation script (Currently supports Arch-based with [yay](https://github.com/Jguer/yay) only):

```console
 bash <(curl -s https://raw.githubusercontent.com/Neurarian/matshell/refs/heads/master/scripts/install.sh)
```

... and implement the colors into your [hyprland config](https://github.com/Neurarian/NixOS-config/blob/master/home/Liqyid/common/optional/desktop/hypr/hyprland.nix#L39) to your liking.

> [!TIP]
> Use Hyprland layerrules to add some blur to the shell for smoother visuals.

```
layerrule=blur, bar
layerrule=blur, gtk4-layer-shell
layerrule=ignorealpha 0.2, bar
layerrule=ignorealpha 0.2, gtk4-layer-shell
```

> [!NOTE]
> After a first launch, edit the autogenerated config.json in ~/.config/ags/ to add the shell commands for your terminal, file-manager, browser, resource monitor, and audio control apps to the shell. Defaults are Wezterm, Nautilus, Zen, Resources, and pwvucontrol.
> You can also add more advanced bluetooth and wifi apps to the config.json. Their toggles can also be disabled if the matshell controls alone are sufficient for you. Defaults are overskride and gnome-control-center.
> Add your wallpaper directory to the config.json to pick wallpapers either randomly via `matshell wall-rand` or from the wp picker.

<details>
  <summary>Manual install</summary>

...Or do it manually by installing the dependencies above and cloning this repo.

**❗Make sure to create a backup of your current config if you want to keep it❗**

```console
  git clone --depth 1 "https://github.com/Neurarian/matshell" "$XDG_CONFIG_HOME/ags/"
```

Finally, add this to your matugen config:

```toml
[templates.gtk3]
input_path = "~/.config/ags/matugen/templates/gtk.css"
output_path = "~/.config/gtk-3.0/gtk.css"

[templates.gtk4]
input_path = "~/.config/ags/matugen/templates/gtk.css"
output_path = "~/.config/gtk-4.0/gtk.css"

[templates.ags]
input_path = "~/.config/ags/matugen/templates/ags.scss"
output_path = "~/.config/ags/style/abstracts/_variables.scss"

[templates.hypr]
input_path = "~/.config/ags/matugen/templates/hyprland_colors.conf"
output_path = "~/.config/hypr/hyprland_colors.conf"

[templates.hyprlock]
input_path = "~/.config/ags/matugen/templates/hyprlock_colors.conf"
output_path = "~/.config/hypr/hyprlock_colors.conf"
```

</details>

#### ❄️ Nix

You can generally test out matshell via the flake exposed package `nix run github:Neurarian/matshell` (`nix run github:Neurarian/matshell#matshell-river` for the River version). To integrate matshell into your home-manager config you can enable dedicated options from the module:

```nix
# ...

imports = [
  inputs.matshell.homeManagerModules.default
];

programs.matshell= {
  # Enable the basic shell
  enable = true; 
  # Enable a systemd service for matshell
  autostart = true;
  # Compositor you are using. Defaults to hyprland.
  compositor = "hyprland";
  # This sets up the entire matugen config & templates.
  # If you already have matugen set up you may want to omit this.
  # To use the hyprland/hyprlock templates, you would still need to
  # import the generated files and add the color aliases to your config as desired.
  matugenConfig = true;
};
#...

```

> [!NOTE]
> As I don't want to overwrite changes people potentially apply to the stylesheets in ~/.config/ags/ or even their current configs, I do not replace config files already present at ~/.config/ags/ on rebuild. This means, If a new version of matshell changed something style related, you may need to delete the old ~/.config/ags/ folder manually and rebuild again for the stylesheets to be up-to-date.

## Acknowledgements

This project wouldn't be possible without:

- [Aylur](https://github.com/Aylur) for the powerful widget toolkit and the [gnofi](https://github.com/Aylur/gnofi) picker
- [fufexan's dotfiles](https://github.com/fufexan/dotfiles) for the initial inspiration and foundation
- [matugen](https://github.com/InioX/matugen) for the amazing Material Color theming utility
- [kotontrion](https://github.com/kotontrion/kompass) for the GTK4 CAVA Catmull-Rom spline widget
- [ARKye03](https://github.com/ARKye03) for the GTK4 circular progress widget which is currently still on its way to be merged into Astal
- [saimoomedits' eww-widgets](https://github.com/saimoomedits/eww-widgets) for design influence
- [end-4's dots-hyprland](https://github.com/end-4/dots-hyprland) for some inspiration on the color generation

## More Showcases

### Video Demo Desktop

<p align="center">

https://github.com/user-attachments/assets/7a7851e3-9ebc-4f52-8b0f-e9a062122d9e

</p>

### 🌚 Dark Theme (Desktop)

<p align="center">
<b>Floating mode</b>
</p>
  
<img width="3439" height="1440" alt="20251013_224915" src="https://github.com/user-attachments/assets/f456f4fe-69e8-4751-be95-aa85a6bd7ff3" />

<p align="center">
<b>Full bar mode & cava in bar</b>
</p>

<img width="3439" height="1440" alt="20251010_003407" src="https://github.com/user-attachments/assets/64dd646d-c3c0-4190-b5da-5c7e9503e905" />

### 🌞 Light Theme

<p align="center">
<b> Square bar with rounded screen corners & Hyprland blur</b>
</p>

<img width="3439" height="1441" alt="2025-09-18T19:08:46,034329229+02:00" src="https://github.com/user-attachments/assets/b61585b6-e17c-4d43-98e8-3e49962ae108" />

<details>
   <summary><h3></b>Detailed Widget List</h3></summary>

- **Main Status Bar**

![2025-04-10 18-58-06](https://github.com/user-attachments/assets/1952d0ed-c9ca-4966-a91f-5f45aae5fdf6)

![2025-04-10 23-47-32](https://github.com/user-attachments/assets/e05e8861-2e76-417a-a7b3-369f155b20c1)

- Laptop (Light)

![2025-03-23T18:37:29,615714672+01:00](https://github.com/user-attachments/assets/8656aa43-7793-476b-9e12-f0a58eeccbfb)

- Desktop (Dark)

![2025-03-23T18:53:49,228938439+01:00](https://github.com/user-attachments/assets/01e4e84c-1901-4532-a924-3a86696aa22c)

- **App Launcher**
- Light

![2025-03-23T18:41:51,470421774+01:00](https://github.com/user-attachments/assets/ae8b69a8-8fc1-4a48-a18e-77a8af6f83c8)

- Dark

![2025-03-23T18:56:24,165287965+01:00](https://github.com/user-attachments/assets/3760a241-913f-4d31-a90b-f1a6d85b59bf)

- **Logout Menu**
- Light

![2025-03-23T19:00:49,303694058+01:00](https://github.com/user-attachments/assets/df572fad-1783-45fe-b7ca-a43fd3d55319)

- Dark

![2025-03-23T18:40:10,844462569+01:00](https://github.com/user-attachments/assets/53eb4206-b33d-459c-b3b4-d6cb1154c4f3)

- **Music Player with CAVA**

![2025-04-10T00:02:06,878048376+02:00](https://github.com/user-attachments/assets/cefb1942-4f9b-430e-b499-55ebf32e55e5) ![2025-04-10 18-22-52-8](https://github.com/user-attachments/assets/512b6658-d7e5-44aa-95cc-7a180cf28203)

- **Notifications**
- Light

![2025-03-23T18:42:09,143344616+01:00](https://github.com/user-attachments/assets/cacd60a8-4941-40d4-802c-54a683ff8b34)

- Dark

![2025-03-23T19:05:38,240008405+01:00](https://github.com/user-attachments/assets/c949ade2-2d3b-4678-a36e-0ff725859e05)

- **On Screen Display**
- Light

![2025-03-23T18:47:25,513704415+01:00](https://github.com/user-attachments/assets/86351939-d32a-4063-bd6f-c4f2b9e7292d)

- Dark

![2025-03-23T19:06:59,375609741+01:00](https://github.com/user-attachments/assets/3ea5eb01-1042-4740-ad88-ee59212dc50c)

- **System Menu**
- Laptop (Light)

![2025-03-23T18:38:30,002859605+01:00](https://github.com/user-attachments/assets/c520f03b-f365-4782-8008-591a8993eaef)

- Desktop (Dark)

![2025-03-23T19:09:22,826684018+01:00](https://github.com/user-attachments/assets/8c701cb4-d675-4bf9-97fa-cf3eceaa9545)

</details>
