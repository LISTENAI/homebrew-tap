class Ling < Formula
  desc "ListenAI local CLI for account, models, chat, app management and docs search"
  homepage "https://github.com/LISTENAI/ling"
  version "0.1.1"
  license "MIT"

  if Hardware::CPU.arm?
    url "https://github.com/LISTENAI/ling/releases/download/v#{version}/ling-v#{version}-aarch64-apple-darwin.tar.gz"
    sha256 "9436783e1a5e0076e12f51e91c4ea8a243e4e2dda5da571f4801720f10dd1466"
  else
    url "https://github.com/LISTENAI/ling/releases/download/v#{version}/ling-v#{version}-x86_64-apple-darwin.tar.gz"
    sha256 "c1f8b3bc5e0423beb9e1f0678652b917402134e4b468160788f819bfc52e5fc4"
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
