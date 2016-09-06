# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

inherit eutils savedconfig toolchain-funcs

DESCRIPTION="a dynamic window manager for X11"
HOMEPAGE="http://dwm.suckless.org/"
SRC_URI="http://dl.suckless.org/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86 ~x86-fbsd"
IUSE="+dmenu rofi xinerama"

REQUIRED_USE="|| ( dmenu rofi )"

DEPEND="
	x11-libs/libX11
	x11-libs/libXft
	dmenu? ( x11-misc/dmenu )
	rofi? ( x11-misc/rofi )
	xinerama? (
		x11-proto/xineramaproto
		x11-libs/libXinerama
	)
"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i \
		-e "s/CFLAGS = -std=c99 -pedantic -Wall -Os/CFLAGS += -std=c99 -pedantic -Wall/" \
		-e "/^LDFLAGS/{s|=|+=|g;s|-s ||g}" \
		-e "s/#XINERAMALIBS =/XINERAMALIBS ?=/" \
		-e "s/#XINERAMAFLAGS =/XINERAMAFLAGS ?=/" \
		-e "s@/usr/X11R6/include@${EPREFIX}/usr/include/X11@" \
		-e "s@/usr/X11R6/lib@${EPREFIX}/usr/lib@" \
		-e "s@-I/usr/include@@" -e "s@-L/usr/lib@@" \
		-e "s/\/freetype2/\ -I\/usr\/include\/freetype2/" \
		config.mk || die
	sed -i \
		-e '/@echo CC/d' \
		-e 's|@${CC}|$(CC)|g' \
		Makefile || die

	GLIBC_VER=`ldd --version | head -n 1 | cut -d \  -f 5`
	TOF=`echo "${GLIBC_VER} >= 2.20" | bc`
	if [ $TOF -eq 1 ]; then
		sed -i -e 's/BSD_SOURCE/DEFAULT_SOURCE/g' config.mk || die
	fi

	restore_config config.h
	eapply_user
}

src_compile() {
	if use xinerama; then
		emake CC=$(tc-getCC) dwm
	else
		emake CC=$(tc-getCC) XINERAMAFLAGS="" XINERAMALIBS="" dwm
	fi
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install

	dodoc README

	save_config config.h
}
