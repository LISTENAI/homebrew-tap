cask "lisem" do
  arch arm: "aarch64", intel: "x86_64"

  version "1.3.0"
  sha256 arm:   "fbb199a7681144cc5096cb497da7f63043c3049e2bfd46ba7874317555995146",
         intel: "ee54011f8f290d208a94ca26bf7c8b46b306a83fbbe02d792375866f5369168e"

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
