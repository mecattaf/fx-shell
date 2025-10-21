{
  description = "Matshell: a GTK4 Material Design desktop shell powered by AGS, Astal & Gnim";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "systems";

    astal = {
      url = "github:aylur/astal";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ags = {
      url = "github:aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.astal = {
        url = "github:aylur/astal";
        inputs.nixpkgs.follows = "nixpkgs";
      };
    };

    matugen = {
      url = "github:InioX/matugen";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    image-hct = {
      url = "github:Neurarian/image-hct";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    astal,
    ags,
    systems,
    flake-parts,
    ...
  }: let
    mkPkgs = system:
      import nixpkgs {
        inherit system;
      };

    mkNativeBuildInputs = system: let
      pkgs = mkPkgs system;
    in (with pkgs; [
      wrapGAppsHook
      gobject-introspection
    ]);

    mkBuildInputs = system: compositor: let
      pkgs = mkPkgs system;
      astalPkgs = astal.packages.${system};

      baseAstalPkgs = with astalPkgs; [
        astal4
        io
        notifd
        apps
        wireplumber
        mpris
        network
        tray
        bluetooth
        cava
        battery
        powerprofiles
      ];

      # Compositor-specific packages
      compositorPkgs =
        if compositor == "river"
        then [astalPkgs.river]
        else if compositor == "hyprland"
        then [astalPkgs.hyprland]
        else throw "Unsupported compositor: ${compositor}. Use 'river' or 'hyprland'.";
    in
      (with pkgs; [
        glib
        gjs
        typescript
        libgtop
        libadwaita
        libsoup_3
        glib-networking
      ])
      ++ baseAstalPkgs
      ++ compositorPkgs;

    mkMatshellPackage = system: compositor: let
      pkgs = mkPkgs system;
      agsPackage = ags.packages.${system}.default;
    in let
      matshell-bundle = pkgs.stdenv.mkDerivation {
        pname = "matshell-${compositor}";
        version = "0.1";

        src = ./.;

        nativeBuildInputs =
          mkNativeBuildInputs system
          ++ [agsPackage];

        buildInputs = mkBuildInputs system compositor;

        installPhase = ''
          mkdir -p $out/bin $out/share
          ags bundle app.ts $out/bin/matshell
          cp -r style $out/share/
          cp -r assets/icons $out/share/
        '';

        preFixup = ''
          gappsWrapperArgs+=(
            --prefix PATH : ${
            pkgs.lib.makeBinPath (with pkgs; [
              libnotify
              dart-sass
              imagemagick
              swww
              cliphist
              wl-clipboard
              inputs.matugen.packages.${system}.default
              inputs.image-hct.packages.${system}.default
            ])
          }
          )
        '';
      };
    in
      pkgs.runCommand "copy-matshell-styles" {
        nativeBuildInputs = [pkgs.makeWrapper];
      } ''
        mkdir -p $out/bin

        # Copy the bundled app
        cp -r ${matshell-bundle}/* $out/

        # Create a wrapper script for matshell to copy files that require mutability out of the store
        mv $out/bin/matshell $out/bin/.matshell-unwrapped

        makeWrapper $out/bin/.matshell-unwrapped $out/bin/matshell \
          --run 'STYLE_DIR="$HOME/.config/ags/style"
                 ICONS_DIR="$HOME/.config/ags/assets/icons"

                 # Check if either directory needs to be set up
                 if [ ! -d "$STYLE_DIR" ] || [ ! -d "$ICONS_DIR" ]; then
                   # Create necessary directories
                   mkdir -p "$STYLE_DIR"
                   mkdir -p "$ICONS_DIR"

                   # Copy style files if source exists and destination is empty
                   if [ -d "'"$out"'/share/style" ]; then
                     cp -r "'"$out"'/share/style/"* "$STYLE_DIR/"
                     echo "Installed Matshell styles to $STYLE_DIR"
                   fi

                   # Copy icon files if source exists and destination is empty
                   if [ -d "'"$out"'/share/assets/icons" ]; then
                     cp -r "'"$out"'/share/assets/icons/"* "$ICONS_DIR/"
                     echo "Installed Matshell icons to $ICONS_DIR"
                   fi

                   # Make copied files writable by the user
                   find "$HOME/.config/ags" -type d -exec chmod 755 {} \;
                   find "$HOME/.config/ags" -type f -exec chmod 644 {} \;
                 fi'
      '';
  in
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = import systems;

      perSystem = {system, ...}: let
        pkgs = mkPkgs system;
        agsPackage = ags.packages.${system}.default;

        mkShellHook = compositor: ''
          echo "Setting up Matshell devenv (${compositor})..."

          # Generate tsconfig.json
          cat > tsconfig.json << EOF
          {
            "compilerOptions": {
              "allowImportingTsExtensions": true,
              "allowJs": true,
              "baseUrl": ".",
              "experimentalDecorators": false,
              "jsx": "react-jsx",
              "jsxImportSource": "ags/gtk4",
              "module": "ES2022",
              "moduleResolution": "Bundler",
              "noImplicitAny": false,
              "paths": {
                "ags/*": ["${agsPackage}/share/ags/js/lib/*"],
                "ags": ["${agsPackage}/share/ags/js/lib/index.ts"]
              },
              "typeRoots": [
                "./@girs"
              ],
              "strict": true,
              "target": "ES2020"
            }
          }
          EOF

          echo "Generated tsconfig.json with AGS path: ${agsPackage}/share/ags/js/lib/"

          # Generate or update types
          if [ ! -d "@girs" ]; then
            echo "Generating @girs types..."
            ags types -d .
            echo "Generated @girs types"
          else
            echo "Updating @girs types..."
            ags types update -d .
            echo "Updated @girs types"
          fi

          echo "Devenv ready"
        '';

        mkDevShell = compositor:
          pkgs.mkShell {
            inputsFrom = [self.packages.${system}."matshell-${compositor}"];
            buildInputs = mkBuildInputs system compositor ++ [agsPackage];
            shellHook = mkShellHook compositor;
          };
      in {
        packages.default = mkMatshellPackage system "hyprland";

        packages.matshell-hyprland = mkMatshellPackage system "hyprland";
        packages.matshell-river = mkMatshellPackage system "river";

        apps = {
          default = {
            type = "app";
            program = "${self.packages.${system}.default}/bin/matshell";
          };

          matshell-hyprland = {
            type = "app";
            program = "${self.packages.${system}.matshell-hyprland}/bin/matshell";
          };

          matshell-river = {
            type = "app";
            program = "${self.packages.${system}.matshell-river}/bin/matshell";
          };
        };

        devShells = {
          default = mkDevShell "hyprland";
          hyprland = mkDevShell "hyprland";
          river = mkDevShell "river";
        };
      };

      flake = {
        homeManagerModules = {
          default = self.homeManagerModules.matshell;
          matshell = import ./nix/hm-module.nix self inputs;
        };
      };
    };
}
