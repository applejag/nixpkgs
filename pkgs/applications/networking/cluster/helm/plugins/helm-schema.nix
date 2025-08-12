{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:
buildGoModule rec {
  pname = "helm-schema";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "losisin";
    repo = "helm-values-schema-json";
    rev = "v${version}";
    hash = "sha256-dttUbP+G2q+IJwoYReSfJVnc/Dix3Bk0H0EkuCuU9Ko=";
  };

  vendorHash = "sha256-+Idcps9Z/56rvlSYVX8cw4Rbg/2Kt9bzhwtN3clQ3XY=";

  ldflags = [
    "-s"
    "-w"
    "-X 'main.Version=v${version}'"
  ];

  # NOTE: Remove the install and upgrade hooks.
  postPatch = ''
    sed -i '/^hooks:/,+2 d' plugin.yaml
  '';

  postInstall = ''
    install -dm755 $out/${pname}/
    mv $out/bin/helm-values-schema-json $out/${pname}/schema
    rm -r $out/bin
    install -m644 -Dt $out/${pname} plugin.yaml plugin.complete
  '';

  meta = {
    description = "Helm plugin for generating values.schema.json from multiple values files ";
    homepage = "https://github.com/losisin/helm-values-schema-json";
    maintainers = with lib.maintainers; [ applejag ];
    license = lib.licenses.mit;
  };
}
