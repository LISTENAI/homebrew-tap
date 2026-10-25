cask "lisem" do
  arch arm: "aarch64", intel: "x86_64"

  version "1.1.0"
  sha256 arm:   "72af153d9e0a6f9f7b0ca9b6d5871999d9f35501dc221fabc43bf447cd4150f6",
         intel: "7fa4e879dc783584b8e479f48077ab01ba5559b0d523c79e3c3fd1e63f689953"

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
