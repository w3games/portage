# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/lib/cvs/cpm/gentoo/cpm.ebuild,v 1.6 2005/09/05 06:57:21 harry Exp $

EAPI=5
inherit eutils

myP="${P/_beta/}"
myPV="${PV/_beta/}"

DESCRIPTION="This program is a small console tool to manage passwords and store them public key encrypted in a file - even for more than one person.  The encryption is handled via GnuPG so you can access the programs data via gpg as well, in case you want to have a look inside. The data is stored as XML so it's even possible to reuse the data for some other purpose."
HOMEPAGE="http://www.harry-b.de/dokuwiki/doku.php?id=harry:cpm"
SRC_URI="https://github.com/comotion/${PN}/archive/${myPV}.tar.gz -> ${myP}.tar.gz
		 http://www.harry-b.de/downloads/${myP}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	>=app-crypt/gpgme-1.0.2
	dev-libs/cdk
	dev-libs/dotconf
	dev-libs/libxml2
	sys-devel/gettext
	sys-libs/cracklib
	sys-libs/ncurses
"

S=${WORKDIR}/${myP}

src_prepare() {
	epatch "${FILESDIR}/cpm-0.32-update-ncurses5-to-ncurses6.patch"
}

src_compile() {
	local myconf="--with-crack-dict=/usr/lib/cracklib_dict --with-cdk-v4"

	econf \
		${myconf} || die "econf failed"

	emake || die "compile problem"
}

src_install() {
	make DESTDIR="${D}" install || die "install failed"

	dodoc -r docs/*

	insopts -m0644
	insinto /usr/share/doc/${PF}/import
	doins -r import/*

	insinto /etc
	newins conf/cpmrc-default cpmrc
}

pkg_postinst() {
	einfo "If running cpm from non-root user gives you some error like:"
	einfo ""
	einfo "out of memory error - tried to allocate 16 byte."
	einfo ""
	einfo "You must raise the limit of the ulimit for 'max memory size':"
	einfo "      ulimit -l 5120"
	einfo "before running cpm."
	einfo ""
}
