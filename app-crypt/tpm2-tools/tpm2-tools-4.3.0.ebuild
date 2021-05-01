# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Tools for the TPM 2.0 TSS"
HOMEPAGE="https://github.com/tpm2-software/tpm2-tools"
SRC_URI="https://github.com/tpm2-software/${PN}/releases/download/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+fapi libressl"

# Integration test are now run as part of the testing suite, which will fail
# because none of the supported TPM emulators are in Portage. In a future
# version of tpm2-tools, swtpm will be supported and the tests can be run.
RESTRICT="test"

RDEPEND="net-misc/curl:=
	>=app-crypt/tpm2-tss-2.4.0:=[fapi?]
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"
PATCHES=(
	"${FILESDIR}/${PN}-4.2.1-libressl.patch"
	"${FILESDIR}/${PN}-4.3.0-Remove-WError.patch"
)

src_prepare() {
	eautoreconf
	default
}

src_configure() {
	econf \
		$(use_enable fapi) \
		$(use_enable !libressl hardening)
}
