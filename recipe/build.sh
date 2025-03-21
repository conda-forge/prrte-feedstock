set -ex

if [[ "$CONDA_BUILD_CROSS_COMPILATION" == "1" ]]; then
  # need to deal with pmixcc for cross compiling
  export PMIX_CC=$CC
  export PMIX_PREFIX=$PREFIX
  # this works because `--with-pmix` _only_ searches for pmixcc,
  # not libs which use pkg-config
  export PMIX_BIN_PREFIX=$BUILD_PREFIX
fi

./configure \
  --with-libevent=$PREFIX \
  --with-hwloc=$PREFIX \
  --with-pmix=${PMIX_BIN_PREFIX:-$PREFIX} \
  --with-sge \
  --enable-ipv6 \
  --enable-prte-prefix-by-default \
  --disable-dependency-tracking \
  --prefix=$PREFIX || (tail -n 1000 config.log; exit 1)

make -j ${CPU_COUNT:-1}
make install

# pcc symlink to pmixcc is wrong for cross compilation
# first, make sure this really is a symlink we are fixing
test -L $PREFIX/bin/pcc
rm $PREFIX/bin/pcc
ln -s pmixcc $PREFIX/bin/pcc
test -f $PREFIX/bin/pcc
