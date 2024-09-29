{
  description = "My Personal Laptop Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
  let
    configuration = { pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages = with pkgs;
        [ 
          vim
          k9s
          kubectl
          krew
          rustup
                  elixir
        mysql80
        # development tools
        lazygit
        docker
        doctl
        gh
        helix
        git-lfs

        # charm.sh tools
        gum
        glow
        skate
        soft-serve

        # general tools
        starship
        ripgrep
        fzf
        btop
        stow
        ranger
        zoxide
        ansible
        fd
        zellij
        eza
        lf
        nnn
        parallel

        #fun
        thefuck # type 'fuck' after making a typo on a shell command.
        spotifyd #spotify daemon, needed for spotify TUI
        # spotify-tui #run spotify in the terminal, I only use this on Arch, not macOS
        lolcat
        taskwarrior-tui
        postgresql
        hexyl

        ];

      # Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;
      # nix.package = pkgs.nix;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh.enable = true;  # default shell on catalina
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";

      system.defaults = {
        # dock 
        dock.autohide = true;
        dock.mru-spaces = false;
        dock.orientation = "bottom";
       # finder 
       finder.AppleShowAllExtensions = true; 
       finder.AppleShowAllFiles = true; 
       finder.FXPreferredViewStyle = "clmv";
      };
      
      # HomeBrew = 
      homebrew.enable = true;
      homebrew.brewPrefix = "/usr/local/bin";
      homebrew.brews = 
        [
          "doctl"
          "amp"
          "argocd"
          "argocd-autopilot"
          "argocd-vault-plugin"
          "autoconf"
          "awk"
          "brotli"
          "ca-certificates"
          "cairo"
          "capstone"
          "cmake"
          "coreutils"
          "curl"
          "diffutils"
          "docker"
          "docker-completion"
          "doctl"
          "dtc"
          "elixir"
          "erlang"
          "fontconfig"
          "freetype"
          "fribidi"
          "gcc"
          "gdk-pixbuf"
          "gettext"
          "glib"
          "gmp"
          "gnu-sed"
          "gnu-tar"
          "gnutls"
          "graphite2"
          "grep"
          "harfbuzz"
          "icu4c"
          "jansson"
          "jpeg-turbo"
          "jq"
          "ldns"
          "libcbor"
          "libevent"
          "libfido2"
          "libidn2"
          "liblinear"
          "libmpc"
          "libnghttp2"
          "libpng"
          "librsvg"
          "libslirp"
          "libssh"
          "libssh2"
          "libtasn1"
          "libtiff"
          "libtool"
          "libunistring"
          "libusb"
          "libx11"
          "libxau"
          "libxcb"
          "libxdmcp"
          "libxext"
          "libxrender"
          "libyaml"
          "lima"
          "little-cms2"
          "lz4"
          "lzo"
          "m4"
          "make"
          "mpdecimal"
          "mpfr"
          "ncurses"
          "nettle"
          "ninja"
          "nmap"
          "oniguruma"
          "openldap"
          "openssh"
          "openssl@3"
          "p11-kit"
          "pango"
          "pcre2"
          "pipx"
          "pixman"
          "pkg-config"
          "python-argcomplete"
          "python@3.11"
          "python@3.12"
          "qemu"
          "readline"
          "rtmpdump"
          "snappy"
          "speedtest-cli"
          "sqlite"
          "texinfo"
          "tmux"
          "tree"
          "tree-sitter"
          "unbound"
          "unixodbc"
          "utf8proc"
          "vde"
          "wxwidgets"
          "xorgproto"
          "xz"
          "yubikey-agent"
          "zstd"
        ];

      homebrew.casks = 
      [
       "aerospace"
          "alacritty"
          "flutter"
          "font-hack-nerd-font"
          "wezterm"
      ];
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#Bens-BlackBook-Pro
    darwinConfigurations."Bens-BlackBook-Pro" = nix-darwin.lib.darwinSystem {
      modules = [ configuration ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."Bens-BlackBook-Pro".pkgs;
  };
}
