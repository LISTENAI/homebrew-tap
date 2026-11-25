cask "lisem" do
  arch arm: "aarch64", intel: "x86_64"

  version "1.4.5"
  sha256 arm:   "a4a9671107933337883f27405cf81aa4d7cf89b494469d5d319be93ebff5ccce",
         intel: "205b730b96c83fe3451b66431b351d6843a79f76ece666b62e0ffa21f6101399"

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
