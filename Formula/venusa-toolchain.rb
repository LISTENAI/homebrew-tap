class VenusaToolchain < Formula
  desc "Nuclei RISC-V bare-metal GNU toolchain (LISTENAI build) for VenusA / CSK6"
  homepage "https://github.com/LISTENAI/riscv-gnu-toolchain"
  version "2025.10-r1"
  license "GPL-3.0-or-later"

  if Hardware::CPU.arm?
    url "https://github.com/LISTENAI/riscv-gnu-toolchain/releases/download/listenai/nuclei-2025.10/r1/riscv-gnu-toolchain-macos-arm64-nuclei-2025.10-r1.tar.gz"
    sha256 "6c006244ef8f197644808aa39a81f0320b8b4b900e0dc88a75770c8f44acf965"
  else
    url "https://github.com/LISTENAI/riscv-gnu-toolchain/releases/download/listenai/nuclei-2025.10/r1/riscv-gnu-toolchain-macos-x86_64-nuclei-2025.10-r1.tar.gz"
    sha256 "eba5cdd29a19fb4db34aaa165a63c541efa34168b17d0662cb0a1cba2424e30e"
  end

  # A cross toolchain: its riscv64-unknown-elf-* tools are reached through
  # NUCLEI_TOOLCHAIN_PATH, not symlinked into the global prefix, so the arcs
  # and venusa toolchains can be installed side by side.
  keg_only "it is a cross toolchain reached via NUCLEI_TOOLCHAIN_PATH"

  depends_on "gmp"
  depends_on :macos
  # GDB links these at runtime; everything else is self-contained.
  depends_on "mpfr"

  def install
    prefix.install Dir["*"]
  end

  def caveats
    <<~EOS
      Point your project's build at this toolchain with:
        export NUCLEI_TOOLCHAIN_PATH=#{opt_prefix}
    EOS
  end

  test do
    assert_match "riscv64-unknown-elf",
      shell_output("#{opt_prefix}/bin/riscv64-unknown-elf-gcc -dumpmachine")
  end
end
