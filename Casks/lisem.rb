cask "lisem" do
  arch arm: "aarch64", intel: "x86_64"

  version "1.4.3"
  sha256 arm:   "caf9e2a8d81bed5c19a9de734f254cfa3dd68fe3a0cc3b1a6f2852512eafb57d",
         intel: "d3eabb1ed2318cd5c83a3f3696f3f4f1a2c1c0d65db30ac81a0326506abcf732"

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
