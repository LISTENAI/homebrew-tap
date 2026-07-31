class Ling < Formula
  desc "ListenAI local CLI for account, models, chat, app management and docs search"
  homepage "https://github.com/LISTENAI/ling"
  version "1.0.0"
  license "MIT"

  if Hardware::CPU.arm?
    url "https://github.com/LISTENAI/ling/releases/download/v#{version}/ling-v#{version}-aarch64-apple-darwin.tar.gz"
    sha256 "02b5fd14c56f7b48c0dd131356e27b2d3c2c311164b940bdbbf2201ac52782cc"
  else
    url "https://github.com/LISTENAI/ling/releases/download/v#{version}/ling-v#{version}-x86_64-apple-darwin.tar.gz"
    sha256 "56b22d90e1dd351a64a68d8990bbca6052f8bcf3a87ab5c1a72807431da2e862"
  end

  def install
    bin.install "ling"
  end

  def caveats
    <<~EOS
      To get started:
        ling login

      Your API Key is saved to ~/.config/listenai/ling/config.json.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ling --version")
  end
end
