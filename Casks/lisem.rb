cask "lisem" do
  arch arm: "aarch64", intel: "x86_64"

  version "0.8.0"
  sha256 arm:   "e2bfd6183c1760e7465d916e0b839bb7af7709acc677e53ca90c262e83ca3f62",
         intel: "9bf8214c0252b25d965314ad9f5950060208d300426d740f5049be2fee58c35a"

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
