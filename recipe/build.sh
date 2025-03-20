set -ex

if [[ "$CONDA_BUILD_CROSS_COMPILING" == "1" ]]; then
  # need to deal with pmixcc for cross compiling
  export PMIX_CC=$CC
  export PMIX_PREFIX=$PREFIX
fi

./configure \
  --with-libevent=$PREFIX \
  --with-hwloc=$PREFIX \
  --with-pmix=$PREFIX \
  --with-sge \
  --enable-ipv6 \
  --enable-prte-prefix-by-default \
  --disable-dependency-tracking \
  --prefix=$PREFIX

make -j ${CPU_COUNT:-1}
make install
