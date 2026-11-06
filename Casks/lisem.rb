cask "lisem" do
  arch arm: "aarch64", intel: "x86_64"

  version "1.2.1"
  sha256 arm:   "05ac3ba3960713fca083da6d6cae64596e4a792f32d07db567f20963c32c3811",
         intel: "c5905a95ba8398de8f814aedd0348d2845c2743be2085ddc697b49d9e106202b"

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
