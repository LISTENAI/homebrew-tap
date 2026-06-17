class Cskburn < Formula
  desc "Flashing tool for LISTENAI CSK series chips"
  homepage "https://github.com/LISTENAI/cskburn"
  version "1.31.0"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/LISTENAI/cskburn/releases/download/v#{version}/cskburn-darwin-arm64.tar.xz"
      sha256 "7199ef1fbfe0f9a0a33d8e2e23dd64d6de32672938c6b7f5a8cf7cb5b12dfbad"
    end
    on_intel do
      url "https://github.com/LISTENAI/cskburn/releases/download/v#{version}/cskburn-darwin-x64.tar.xz"
      sha256 "262191f1c4794f3eeb5a5562e942257e0b7776b70f7d1ccf0c4d922da53ce281"
    end
  end

  def install
    bin.install "cskburn"
  end

  def caveats
    <<~EOS
      Driving cskburn from an AI coding assistant? It ships a skill so the
      assistant can flash chips for you:

        npx skills add LISTENAI/cskburn
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cskburn --version")
  end
end
