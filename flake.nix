{
  description = "learn-yesod";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = inputs:
    let
      overlay = final: prev: {
        haskell = prev.haskell // {
          packageOverrides = hfinal: hprev:
            prev.haskell.packageOverrides hfinal hprev // {
              learnYesod = hfinal.callCabal2nix "learn-yesod" ./. { };
            };
        };
        PKGNAME = final.haskell.lib.compose.justStaticExecutables final.haskellPackages.learnYesod;
      };
      perSystem = system:
        let
          pkgs = import inputs.nixpkgs { inherit system; overlays = [ overlay ]; config = { allowUnfree = true; };}; # config = { allowUnfree = true; };
          hspkgs = pkgs.haskellPackages;
          vscodiumWithExtensions = (pkgs.vscode-with-extensions.override {
            vscode = pkgs.vscodium;
            vscodeExtensions = with pkgs.vscode-extensions; [
              asvetliakov.vscode-neovim
              dracula-theme.theme-dracula
              haskell.haskell
              jnoortheen.nix-ide
              justusadam.language-haskell
              mkhl.direnv
            ];
            }
          );
        in
        {
          devShell = hspkgs.shellFor {
            withHoogle = true;
            packages = p: [ p.learnYesod ];
            buildInputs = [
              hspkgs.cabal-install
              hspkgs.haskell-language-server
              hspkgs.hlint
              hspkgs.ormolu
              pkgs.bashInteractive
              pkgs.zlib
              vscodiumWithExtensions
            ];
          };
          defaultPackage = pkgs.learnYesod;
        };
    in
    { inherit overlay; } // inputs.flake-utils.lib.eachDefaultSystem perSystem;
}