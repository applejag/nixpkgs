{
  lib,
  stdenv,
  fetchFromGitHub,
  boost,
  libX11,
  libGL,
  liblo,
  libjack2,
  ladspaH,
  lv2,
  pkg-config,
  rubberband,
  libsndfile,
  fftwFloat,
  libsamplerate,
}:

stdenv.mkDerivation rec {
  pname = "zam-plugins";
  version = "4.4";

  src = fetchFromGitHub {
    owner = "zamaudio";
    repo = "zam-plugins";
    rev = version;
    hash = "sha256-pjnhDavKnyQjPF4nUO+j1J+Qtw8yIYMY9A5zBMb4zFU=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    boost
    libX11
    libGL
    liblo
    libjack2
    ladspaH
    lv2
    rubberband
    libsndfile
    fftwFloat
    libsamplerate
  ];

  postPatch = ''
    patchShebangs ./dpf/utils/generate-ttl.sh
  '';

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://www.zamaudio.com/?p=976";
    description = "Collection of LV2/LADSPA/VST/JACK audio plugins by ZamAudio";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
  };
}
