cask "lisem" do
  arch arm: "aarch64", intel: "x86_64"

  version "0.2.0"
  sha256 arm:   "ca393b8f50a32d44d67ef852f32bdb04c705aea5c09d875e4881b2c59872e2dd",
         intel: "8a67267faee34cbb757283821a3e0d458366dce6d872d8d2a4c8db16fddf0df3"

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
