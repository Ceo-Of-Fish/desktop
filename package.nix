{
  lib,
  appimageTools,
  fetchurl,
  makeWrapper,
  libgpg-error,
  webkitgtk_4_1,
  gtk3,
  libappindicator-gtk3,
  alsa-lib,
  dbus,
  libsecret,
}:

let
  pname = "capsule";
  version = "0.5.5";

  src = fetchurl {
    url = "https://github.com/getcapsule/desktop/releases/download/v${version}/capsule_${version}_amd64.AppImage";
    hash = "sha256-J9DGxNB5fFIJKb1DegemA7E2aXRBHZn9C3o33hSpU3U=";
  };

appimageTools.wrapType2 {
  inherit pname version src;

  nativeBuildInputs = [ makeWrapper ];

  extraPkgs = _: [
    libgpg-error
    webkitgtk_4_1
    gtk3
    libappindicator-gtk3
    alsa-lib
    dbus
    libsecret
  ];

  extraInstallCommands = ''
    install -Dm444 ${appimageContents}/capsule.desktop -t $out/share/applications
    cp -r ${appimageContents}/usr/share/icons $out/share/
    substituteInPlace $out/share/applications/capsule.desktop \
      --replace-quiet 'Exec=AppRun' 'Exec=capsule'

    wrapProgram $out/bin/capsule \
      --set-default GDK_BACKEND wayland,x11
  '';

  meta = {
    description = "Open-source music player for Windows and Linux with local files, Navidrome, and public streaming sources";
    homepage = "https://github.com/getcapsule/desktop";
    license = lib.licenses.gpl3Only;
    platforms = [ "x86_64-linux" ];
    mainProgram = pname;
  };
}
