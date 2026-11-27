cask "lisem" do
  arch arm: "aarch64", intel: "x86_64"

  version "1.4.7"
  sha256 arm:   "69bf8cd44e877572fa420da5526ff7eae5a28de2263e2f952fb0166904a99ecb",
         intel: "6cac33bfc88873af772e4562bac0a8019c956d176f47349a4315e58095ff69a3"

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
