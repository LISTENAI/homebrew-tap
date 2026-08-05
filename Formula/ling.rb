class Ling < Formula
  desc "ListenAI local CLI for account, models, chat, app management and docs search"
  homepage "https://github.com/LISTENAI/ling"
  version "1.0.1"
  license "MIT"

  if Hardware::CPU.arm?
    url "https://github.com/LISTENAI/ling/releases/download/v#{version}/ling-v#{version}-aarch64-apple-darwin.tar.gz"
    sha256 "af414d7d81b423df1bf04685f4aff56df8cf946f306eead0001a1170103ebd29"
  else
    url "https://github.com/LISTENAI/ling/releases/download/v#{version}/ling-v#{version}-x86_64-apple-darwin.tar.gz"
    sha256 "1461d4d627f89bb8486fe3b1d686b975573606ca6ecb014c80204a1c1ca00e55"
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
