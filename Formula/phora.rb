class Phora < Formula
  desc "A git-based artifact package manager and multiplexer for content-addressed file distribution"
  homepage "https://github.com/srnnkls/phora"
  version "0.6.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/srnnkls/phora/releases/download/v0.6.0/phora-aarch64-apple-darwin.tar.xz"
      sha256 "7f91b90f8392d9bf11f7125e4d9c9a16065a639f17fa194f29418a389b4d7b6b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/srnnkls/phora/releases/download/v0.6.0/phora-x86_64-apple-darwin.tar.xz"
      sha256 "47b74fa11e129aab8fc8908d3f945cc4f09171bc2ecfdf23c3875a5d750201ac"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/srnnkls/phora/releases/download/v0.6.0/phora-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "032a7536983355161b41811cd77ff1f8ae8472d68aecedc09aebce4348cf42a0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/srnnkls/phora/releases/download/v0.6.0/phora-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9f4443f3035e9e7f26808cf6af332982bcd95022be06bf175a2156a919cd1ba3"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "phora"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "phora"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "phora"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "phora"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
