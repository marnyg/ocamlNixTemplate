{
  description = "My OCaml project";

  inputs.opam2nix.url = "github:dwarfmaster/opam2nix";
  outputs = { self, nixpkgs, opam2nix }: rec {
    devShell.x86_64-linux = with nixpkgs.legacyPackages.x86_64-linux; mkShell {
      buildInputs = [
        ocaml
        ocamlPackages.dune_3
        opam
      ];
      shellHook = '' 
        export NIX_PATH=nixpkgs=${nixpkgs.outPath}  # set NIX_PATH
        opam switch create my_switch 4.12.0 || opam switch my_switch
        eval $(opam env)
        #opam install . --deps-only
      '';

    };

    packages.x86_64-linux.myOcamlPackage = with nixpkgs.legacyPackages.x86_64-linux; ocamlPackages.buildDunePackage rec {
      pname = "myPro";
      version = "0.1.0";
      duneVersion = "3";
      src = ./.;

      buildInputs = [
        ocamlPackages.core
      ];

      strictDeps = true;

      doCheck = true;
      checkTarget = "test";

      #preBuild = ''
      #  dune build myPro.opam
      #'';


    };
    packages.x86_64-linux.default = packages.x86_64-linux.myOcamlPackage;
    app.x86_64-linux.default = packages.x86_64-linux.myOcamlPackage;
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
  };
}

