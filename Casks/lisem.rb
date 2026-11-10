cask "lisem" do
  arch arm: "aarch64", intel: "x86_64"

  version "1.4.0"
  sha256 arm:   "cee8756bc2df884dd0253093cc97f075a24c514128e24ff89a9e218236797b09",
         intel: "a8aed4984359a1e65d4936c5d8e77da82fdddbe3cc1d3fde4767a87213f1c2ef"

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
