{
  lib,
  stdenvNoCC,
  fetchzip,
}:

let
  packages = [
    {
      name = "arrays";
      version = "7.3.0";
      hash = "sha256-hhoRMVODmiKMLq/6+zw3JTq5heWM1YPcREWF3iTpLzA=";
    }
    {
      name = "bifunctors";
      version = "6.1.0";
      hash = "sha256-Ajg3LIBuX5HBun8WjZpQnlpbKjHOOy9khy5DaEJ1JBc=";
    }
    {
      name = "const";
      version = "6.0.0";
      hash = "sha256-ZGOGdhE9g8RBsAP4FCKv+QZWiHpiEcqGxrjSVvWXJk8=";
    }
    {
      name = "contravariant";
      version = "6.0.0";
      hash = "sha256-6jEDb6lqP3kmT31pX0Nx0ML5Oeh3+HEjbQdrV5BCDqI=";
    }
    {
      name = "control";
      version = "6.0.0";
      hash = "sha256-IfygLtRp/7l+5LfwO/lr+vfSUnHyzhqn6qAvuVOXXBc=";
    }
    {
      name = "distributive";
      version = "6.0.0";
      hash = "sha256-ZXUEFmA9Jmage3r7HaAIKaPrfDPxWvEmioxm86YhPmA=";
    }
    {
      name = "effect";
      version = "4.0.0";
      hash = "sha256-hBhXsfyUjOia/tNYcCzeX9MzwRnGryGs+S1b60Z7CnE=";
    }
    {
      name = "either";
      version = "6.1.0";
      hash = "sha256-keIEHyX3SCE/1EpAvqP1gBvmE1VLnS7LTIe6i/74uYQ=";
    }
    {
      name = "enums";
      version = "6.0.1";
      hash = "sha256-87qT6jWHvjj5DOVVXSANl1mbOHL8EJd8V7blfqR1koo=";
    }
    {
      name = "exceptions";
      version = "6.1.0";
      hash = "sha256-GZb2EMtjonS5W1rGLvrQhmteDMjvo1Sn5ifSGVM+iPc=";
    }
    {
      name = "exists";
      version = "6.0.0";
      hash = "sha256-M6ZHx84fjMzRuqaj6+cCWdeI5C4VTH7ScPA0Vm5bsPk=";
    }
    {
      name = "foldable-traversable";
      version = "6.0.0";
      hash = "sha256-hKTCMAU7ZkQmipurpszqemW2A7TjugCv5/V6XD8Uen4=";
    }
    {
      name = "functions";
      version = "6.0.0";
      hash = "sha256-RK+tBCKcuiNnDjzroMaoJmmuxF6y173KpttahhGtN2Y=";
    }
    {
      name = "functors";
      version = "5.0.0";
      hash = "sha256-lqcCyFfaKvzHcvcZr0WikN/18LH5HW6pwkpcbiM8rHU=";
    }
    {
      name = "gen";
      version = "4.0.0";
      hash = "sha256-TQdu0Qcx1yQmJj2sOOU8+EZQnXj5ut+DZaVUPiWUaf4=";
    }
    {
      name = "identity";
      version = "6.0.0";
      hash = "sha256-wj0l1auv5pZsY3edxY7gQzNZFN5riiwnb7bzN0x3ReU=";
    }
    {
      name = "integers";
      version = "6.0.0";
      hash = "sha256-EcUJIhtlFpoLK/issgxIRlaD6P9e2MdoblpHDW4/PjQ=";
    }
    {
      name = "invariant";
      version = "6.0.0";
      hash = "sha256-vNL6m38Nl4f9RNV/iaZ3YOaIt6J0ViXjJ74PwrYgRyk=";
    }
    {
      name = "lazy";
      version = "6.0.0";
      hash = "sha256-4Tsx006fceKg1Qa68mBZIPg6hiMSZ/VpwwdcJ3S8JgI=";
    }
    {
      name = "lists";
      version = "7.0.0";
      hash = "sha256-bFNuunWmtECDxj1+R+OTwiX+Ok+LfnisOco8HdSKYso=";
    }
    {
      name = "maybe";
      version = "6.0.0";
      hash = "sha256-JHe1DH5QJEzki5vSfwuCTg1dBOiKFTquev68EGSqhYo=";
    }
    {
      name = "newtype";
      version = "5.0.0";
      hash = "sha256-35ZU96seKrczpwSOoUwYvAJE5skW8RMbR0NkipiFy9k=";
    }
    {
      name = "nonempty";
      version = "7.0.0";
      hash = "sha256-UXKqVV9VAE3IWPX9QIWXTCMF1oi16CXNUAMIaT8905U=";
    }
    {
      name = "numbers";
      version = "9.0.1";
      hash = "sha256-DsSPh2BWkH/d4Zd0YaEZCdM4bR6I25pCXU7L3tshjuc=";
    }
    {
      name = "orders";
      version = "6.0.0";
      hash = "sha256-VH6rLQ7pSSVE+QTtTPQjp7cG7IhVpmj9s5JbZ5ps9RA=";
    }
    {
      name = "partial";
      version = "4.0.0";
      hash = "sha256-DGDwl/ZkedaaU+2GNaW1GIEz176fPuI/N1Y1fG6WPBM=";
    }
    {
      name = "prelude";
      version = "6.0.2";
      hash = "sha256-gcmR2vRsdTIdZmIuhiBM507CgI3vI4KCwbHMW0Gh10w=";
    }
    {
      name = "profunctor";
      version = "6.0.1";
      hash = "sha256-BRYgek6yNkBq3UmenoWxy5pGAfzd9G6niCp36hUznJc=";
    }
    {
      name = "refs";
      version = "6.0.0";
      hash = "sha256-lgXRW+ePworvY6Dm2AbkJ5JOTsbHWEf+5Wmo1nxr6nc=";
    }
    {
      name = "safe-coerce";
      version = "2.0.0";
      hash = "sha256-rHhq4r4Ve4zY5qn72bIk/sbwQjVpYxaJX7dSEYXG7Vw=";
    }
    {
      name = "st";
      version = "6.2.0";
      hash = "sha256-GnKQLzETatyMyf/QLgECw8LGdNWLGpzi3A7HOhKgLNA=";
    }
    {
      name = "strings";
      version = "6.0.1";
      hash = "sha256-bXWGbGHqcZwGReCaAtSIurnoWhVgZD5K7qE5JA6iaCU=";
    }
    {
      name = "tailrec";
      version = "6.1.0";
      hash = "sha256-HFf1OxjHZXrwaEV5PtTWZokVT+0xfLRIUb8l8+mQ0cA=";
    }
    {
      name = "tuples";
      version = "7.0.0";
      hash = "sha256-nq/Ud8b2SlBbr6sQWY9KvFu067muiFX+1VkcDC65yCc=";
    }
    {
      name = "type-equality";
      version = "4.0.1";
      hash = "sha256-EJKInHoEEuyYzEu5EdFMyFJ98MgkZhmg5flxsjYkLxo=";
    }
    {
      name = "unfoldable";
      version = "6.0.0";
      hash = "sha256-twmFnEzRzKQ9WlAjt4qRr1l0MKrzrQ9DeOfHRI5W0SA=";
    }
    {
      name = "unsafe-coerce";
      version = "6.0.0";
      hash = "sha256-8dK2ZM4Zw0ILhS7MiBTp4zPAue2OYYboJj2RVacO3sk=";
    }
  ];
  sources = map (
    package:
    package
    // {
      src = fetchzip {
        url = "https://packages.registry.purescript.org/${package.name}/${package.version}.tar.gz";
        inherit (package) hash;
      };
    }
  ) packages;
in
stdenvNoCC.mkDerivation {
  pname = "purescript-package-set";
  version = "81.3.0";
  dontUnpack = true;
  installPhase = ''
    mkdir -p "$out"
    ${lib.concatMapStringsSep "\n" (package: ''
      mkdir -p "$out/${package.name}/${package.version}"
      cp -R "${package.src}/." "$out/${package.name}/${package.version}/"
    '') sources}
  '';
  meta = {
    description = "Pinned PureScript package set; BSD-3-Clause with the MIT-licensed numbers package";
    homepage = "https://github.com/purescript/registry";
    license = with lib.licenses; [
      bsd3
      mit
    ];
    platforms = lib.platforms.all;
  };
}
