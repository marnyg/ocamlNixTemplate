{
  description = "My OCaml project";

  inputs.opam2nix.url = "github:dwarfmaster/opam2nix";
  outputs = { self, nixpkgs, opam2nix }: rec {
    devShell.x86_64-linux = with nixpkgs.legacyPackages.x86_64-linux; mkShell {
      buildInputs = [
        ocaml
        ocamlPackages.dune_3
        opam
        opam2nix.packages.x86_64-linux.opam2nix # Adding opam2nix to the shell path
      ];
      #] ++ builtins.trace "OPAM selection: ${builtins.toJSON (import ./opam-selection.nix {}).selection}";
      #] ++ builtins.attrValues (import ./opam-selection.nix {}).selection;  # Importing from local directory
      #] ++ builtins.attrValues (import ./opam-selection.nix {}).selection;  # Importing from local directory
      shellHook = '' 
        export NIX_PATH=nixpkgs=${nixpkgs.outPath}  # set NIX_PATH
        #opam2nix resolve myPro.opam
        eval $(opam env)
      '';

    };

    packages.x86_64-linux.myOcamlPackage = with nixpkgs.legacyPackages.x86_64-linux; ocamlPackages.buildDunePackage rec {
            pname = "myPro";
            version = "0.1.0";
            duneVersion = "3";
      src = ./.;

            buildInputs = [
            ocamlPackages.core
                # Ocaml package dependencies needed to build go here.
      #buildInputs = (import ./nix {}).selections;  # Importing from local directory
            ];

            strictDeps = true;

      doCheck = true;
      checkTarget = "test";

            preBuild = ''
              dune build myPro.opam
            '';

      
    };
    packages.x86_64-linux.default = packages.x86_64-linux.myOcamlPackage;
    app.x86_64-linux.default = packages.x86_64-linux.myOcamlPackage;
  };
}

