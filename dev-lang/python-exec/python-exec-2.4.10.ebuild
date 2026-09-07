# Distributed under the terms of the GNU General Public License v2
# Autogen by MARK Devkit

EAPI=7
PYTHON_COMPAT=( python{3_9,3_10,3_11} )
inherit python-any-r1

DESCRIPTION="Wrapper for multi-implementation install of Python scripts and executables"
HOMEPAGE="https://github.com/projg2/python-exec"
SRC_URI="https://github.com/projg2/python-exec/releases/download/v2.4.10/python-exec-2.4.10.tar.bz2 -> python-exec-2.4.10.tar.bz2"
LICENSE="BSD-2-Clause"
SLOT="2"
KEYWORDS="*"
IUSE="
python_targets_python3_9
python_targets_python3_10
python_targets_python3_11
"
src_configure() {
	local pyimpls=() i EPYTHON
	for i in "${PYTHON_COMPAT[@]}"; do
	  python_export "${i}" EPYTHON
	  pyimpls+=( "${EPYTHON}" )
	done
	local myconf=(
	  --with-fallback-path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
	  --with-python-impls="${pyimpls[*]}"
	)
	econf "${myconf[@]}"
}
src_install() {
	default
	# Prepare and own the template
	insinto /etc/python-exec
	newins - python-exec.conf \
	  < <(sed -n -e '/^#/p' config/python-exec.conf.example)
	local f
	for f in python{,2,3}; do
	  dosym python-exec2c /usr/bin/"${f}"
	done
	for f in python{,2,3}-config 2to3 idle pydoc pyvenv; do
	  dosym ../lib/python-exec/python-exec2 /usr/bin/"${f}"
	done

}
pkg_preinst() {
	if [[ -e ${EROOT}/etc/python-exec/python-exec.conf ]]; then
	  # preserve current configuration
	  cp "${EROOT}"/etc/python-exec/python-exec.conf \
	    "${ED}"/etc/python-exec/python-exec.conf || die
	else
	  local supported_versions=(
	    python3.9
	    python3.10
	  )
	  local pyimpls=() i
	   for i in ${supported_versions[@]} ; do
	    if use "python_targets_${i}" ; then
	      echo "${i}" >> "${ED}"/etc/python-exec/python-exec.conf || die
	    fi
	  done
	 fi
}


# vim: filetype=ebuild
