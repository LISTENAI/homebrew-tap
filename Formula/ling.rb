class Ling < Formula
  desc "ListenAI local CLI for account, models, chat, app management and docs search"
  homepage "https://github.com/LISTENAI/ling"
  version "0.1.5"
  license "MIT"

  if Hardware::CPU.arm?
    url "https://github.com/LISTENAI/ling/releases/download/v#{version}/ling-v#{version}-aarch64-apple-darwin.tar.gz"
    sha256 "3d047e46a60c3502dc284e71b2da55aa356b6c1ead50b060d692266697e1da5d"
  else
    url "https://github.com/LISTENAI/ling/releases/download/v#{version}/ling-v#{version}-x86_64-apple-darwin.tar.gz"
    sha256 "928426061a80390ac4218edffb62a0de2bf6713a90b663e228c2521fd5922170"
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
