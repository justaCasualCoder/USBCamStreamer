# Maintainer: justaCasualCoder
pkgname=USBCamStreamer
pkgver=0.1
pkgrel=0
pkgdesc="Script for streaming video from USB cam to browser"
url="https://github.com/justaCasualCoder/USBCamStreamer"
arch="all"
license="GPL-V3"
depends="bash ffmpeg"
depends_dev=""
makedepends=""
install=""
subpackages="$pkgname-doc"
source=""
builddir="$srcdir/$pkgname-$pkgver"

package() {
    mkdir -p "$pkgdir"/usr/bin
    mkdir -p "$pkgdir"/usr/share/man/man1

    install -m 755 USBCamStreamer.sh "$pkgdir"/usr/bin/USBCamStreamer
    install -m 644 USBCamStreamer.manpage "$pkgdir"/usr/share/man/man1/USBCamStreamer.1
}

doc() {
    default_doc
}

md5sums=""
