class Ling < Formula
  desc "ListenAI local CLI for account, models, chat, app management and docs search"
  homepage "https://github.com/LISTENAI/ling"
  version "0.1.2"
  license "MIT"

  if Hardware::CPU.arm?
    url "https://github.com/LISTENAI/ling/releases/download/v#{version}/ling-v#{version}-aarch64-apple-darwin.tar.gz"
    sha256 "9205ee71887a5a556f3c3e2a8f0a8aa8d9892098f556edcd28f1ceb11f779ece"
  else
    url "https://github.com/LISTENAI/ling/releases/download/v#{version}/ling-v#{version}-x86_64-apple-darwin.tar.gz"
    sha256 "7835e7536cdfd370463f82661d04f780f50166481844f16e7dbfb7078ad05325"
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
