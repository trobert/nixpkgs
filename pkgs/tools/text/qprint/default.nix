{ fetchurl, lib, stdenv }:

stdenv.mkDerivation rec {
  name = "qprint-1.1";

  src = fetchurl {
    url = "https://www.fourmilab.ch/webtools/qprint/${name}.tar.gz";
    sha256 = "1701cnb1nl84rmcpxzq11w4cyj4385jh3gx4aqxznwf8a4fwmagz";
  };

  doCheck = true;

  checkTarget = "wringer";

  preInstall = ''
    mkdir -p $out/bin
    mkdir -p $out/share/man/man1
  '';

  meta = {
    homepage = "http://www.fourmilab.ch/webtools/qprint/";
    license = lib.licenses.publicDomain;
    description = "Encode and decode Quoted-Printable files";
    maintainers = [ lib.maintainers.tv ];
    platforms = lib.platforms.all;
  };

}
