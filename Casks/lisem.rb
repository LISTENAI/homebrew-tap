cask "lisem" do
  arch arm: "aarch64", intel: "x86_64"

  version "1.4.1"
  sha256 arm:   "4ed2b9f347cfea79788950403f5e10c20a7855ba44d88ed68b4d4e502524d6c5",
         intel: "252e50ddc4fef528ed6f580b377514e5fd8da0c0671dea8134316c53fb5e3d2a"

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
