# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-client/jd/jd-2.8.5_p120826.ebuild,v 1.2 2014/07/14 00:15:14 hasufell Exp $

EAPI=5
inherit eutils autotools autotools-utils

MY_P="${P/_p/-}"
MY_P="${MY_P/_/-}"

DESCRIPTION="gtk2 based 2ch browser written in C++"
HOMEPAGE="https://github.com/yama-natuki/JD
		http://jd4linux.sourceforge.jp/"
SRC_URI="https://github.com/yama-natuki/JD/archive/${MY_P}.tar.gz"
# EGIT_REPO_URI="https://github.com/yama-natuki/${PN}"
# EGIT_BRANCH="test"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa gnome gnutls migemo"

RDEPEND="dev-cpp/gtkmm:2.4
	dev-libs/glib:2
	x11-misc/xdg-utils
	alsa? ( >=media-libs/alsa-lib-1 )
	gnome? ( >=gnome-base/libgnomeui-2 )
	!gnome? (
		x11-libs/libSM
		x11-libs/libICE
	)
	gnutls? ( >=net-libs/gnutls-1.2 )
	!gnutls? ( >=dev-libs/openssl-0.9 )
	migemo? ( app-text/cmigemo )"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/JD-${MY_P}"

AUTOTOOLS_AUTORECONF=1

src_configure() {
	# use gnomeui sm instead of Xorg SM/ICE
	local myeconfargs=(
		--with-xdgopen
		$(use_with gnome sessionlib gnomeui)
		$(use_with !gnome sessionlib xsmp)
		$(use_with alsa)
		$(use_with !gnutls openssl)
		$(use_with migemo)
		$(use_with migemo migemodict /usr/share/migemo/migemo-dict)
	)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install
	doicon ${PN}.png
	domenu ${PN}.desktop
	#dodoc AUTHORS ChangeLog NEWS README
}
