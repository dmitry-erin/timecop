{
  description = "A flake for building Timecop";

  inputs.nixpkgs.url = github:NixOS/nixpkgs/nixos-23.05;

  outputs = { self
  	    , nixpkgs
  	    }
      : {
      defaultPackage.x86_64-linux =
      # Notice the reference to nixpkgs here.
      with import nixpkgs { system = "x86_64-linux"; };
      
      let
        dynamic-linker = stdenv.cc.bintools.dynamicLinker;

      libPath = lib.makeLibraryPath [
        stdenv.cc.cc flutter libX11
      ];

      in stdenv.mkDerivation rec {

        name = "timecop";
        
        nativeBuildInputs = [ autoPatchelfHook flutter ];

        buildInputs = [ flutter ];
        
        src = self;
        
        buildPhase = "flutter build linux --release;";
        installPhase = "mkdir -p $out/bin; mv -t $out/bin build/linux/x64/release/bundle/timecop";
      };

  };
}
