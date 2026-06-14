class ArcsToolchain < Formula
  desc "Nuclei RISC-V bare-metal GNU toolchain (LISTENAI build) for ARCS / LS26"
  homepage "https://github.com/LISTENAI/riscv-gnu-toolchain"
  version "2025.02-r1"
  license "GPL-3.0-or-later"

  if Hardware::CPU.arm?
    url "https://github.com/LISTENAI/riscv-gnu-toolchain/releases/download/listenai/nuclei-2025.02/r1/riscv-gnu-toolchain-macos-arm64-nuclei-2025.02-r1.tar.gz"
    sha256 "f8b33dad0b9ff6422c9cc3cfc6811d69d47f321311878047eefc46664e60c1c0"
  else
    url "https://github.com/LISTENAI/riscv-gnu-toolchain/releases/download/listenai/nuclei-2025.02/r1/riscv-gnu-toolchain-macos-x86_64-nuclei-2025.02-r1.tar.gz"
    sha256 "07dd19ed71957a1e4421110871a8dc8153e9edf285ec9b33b0a2a05622b99f34"
  end

  # A cross toolchain: its riscv64-unknown-elf-* tools are reached through
  # NUCLEI_TOOLCHAIN_PATH, not symlinked into the global prefix, so the arcs
  # and venusa toolchains can be installed side by side.
  keg_only "it is a cross toolchain reached via NUCLEI_TOOLCHAIN_PATH"

  # GDB links gmp/mpfr at runtime; everything else is self-contained.
  depends_on "gmp"
  depends_on :macos
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
