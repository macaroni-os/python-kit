# Distributed under the terms of the GNU General Public License v2
# Autogen by MARK Devkit

EAPI=7
PYTHON_COMPAT=( python3+ )
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
	if [[ -e ${EROOT}etc/python-exec/python-exec.conf ]]; then
	  # preserve current configuration
	  cp "${EROOT}"etc/python-exec/python-exec.conf \
	    "${ED}"etc/python-exec/python-exec.conf || die
	else
	  # preserve previous Python version preference
	  local py old_pythons=()
	  for py in 3; do
	    local target=
	    if [[ -L ${EROOT}/usr/bin/python${py} ]]; then
	      # check the older symlink format
	      target=$(readlink "${EROOT}/usr/bin/python${py}")
	      [[ ${target} == python?.? ]] || target=
	    fi
	    if [[ ${target} && ${old_pythons[0]} != ${target} ]]; then
	      old_pythons+=( "${target}" )
	    fi
	  done
	  if [[ ${old_pythons[@]} ]]; then
	    echo "${old_pythons[*]}" \
	      >> "${ED}"etc/python-exec/python-exec.conf || die
	  fi
	fi
}


# vim: filetype=ebuild
