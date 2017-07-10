# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_4 python3_5 python3_6 )
inherit distutils-r1 git-r3

DESCRIPTION="A complete replacement for i3status"
HOMEPAGE="https://github.com/fusion809/i3pystatus"
EGIT_REPO_URI=( git://github.com/enkore/${PN}.git )
LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

# Some deps like dev-python/colour are needed but not found in Portage Tree
DEPEND=""
RDEPEND="${DEPEND}"

src_unpack() {
	default_src_unpack
	git-r3_src_unpack
}
