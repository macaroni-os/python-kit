# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_4 python3_5 python3_6 )
inherit distutils-r1

DESCRIPTION="A complete replacement for i3status"
HOMEPAGE="https://github.com/enkore/i3pystatus"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# Some deps like dev-python/colour are needed but not found in Portage Tree
DEPEND=""
RDEPEND="${DEPEND}"
