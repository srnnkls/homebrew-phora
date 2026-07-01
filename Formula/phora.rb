class Phora < Formula
  desc "A git-based artifact package manager and multiplexer for content-addressed file distribution"
  homepage "https://github.com/srnnkls/phora"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/srnnkls/phora/releases/download/v0.1.2/phora-aarch64-apple-darwin.tar.xz"
      sha256 "8191d0752a0fd89cbc752290d80024360cf1b73649e9511a9cdb02f679f9f06c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/srnnkls/phora/releases/download/v0.1.2/phora-x86_64-apple-darwin.tar.xz"
      sha256 "53f145866f1ceabe4ab6606d2bdbb0955b5fbbf97df49d31c97ddb10207924d6"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/srnnkls/phora/releases/download/v0.1.2/phora-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3ccd2c7c869aa317778a51358d0c46995f869776deb65a110eb23473c42d7e0c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/srnnkls/phora/releases/download/v0.1.2/phora-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "657845104b308700d0543cedbd2f4192b140d37265faa2374ec08bc19fb42752"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-apple-darwin":                {},
    "x86_64-unknown-linux-gnu":           {},
    "x86_64-unknown-linux-musl-dynamic":  {},
    "x86_64-unknown-linux-musl-static":   {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "phora" if OS.mac? && Hardware::CPU.arm?
    bin.install "phora" if OS.mac? && Hardware::CPU.intel?
    bin.install "phora" if OS.linux? && Hardware::CPU.arm?
    bin.install "phora" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
