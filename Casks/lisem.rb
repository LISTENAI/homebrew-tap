cask "lisem" do
  arch arm: "aarch64", intel: "x86_64"

  version "1.4.6"
  sha256 arm:   "6f844cc2bc765b887e6948f999e20cc922091413889b498bedd372076d01ba3e",
         intel: "086deb0640e39461dd5a0c8543a71480d8af2c94e366a889bc8a9c036678c8e7"

  url "https://github.com/LISTENAI/Lisem/releases/download/v#{version}/Lisem-darwin-#{arch}.tar.gz"
  name "Lisem"
  desc "Run and debug firmware for LISTENAI devices"
  homepage "https://github.com/LISTENAI/Lisem"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :sequoia

  app "Lisem.app"
  binary "#{appdir}/Lisem.app/Contents/MacOS/lisem"

  caveats <<~EOS
    Lisem is not notarized. If macOS blocks the first launch, allow it in
    System Settings > Privacy & Security.
  EOS
end
