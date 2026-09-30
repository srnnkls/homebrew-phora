class Phora < Formula
  desc "A git-based artifact package manager and multiplexer for content-addressed file distribution"
  homepage "https://github.com/srnnkls/phora"
  version "0.3.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/srnnkls/phora/releases/download/v0.3.3/phora-aarch64-apple-darwin.tar.xz"
      sha256 "04190bdeb6f53d70d00f36f1d2c128582b6953995a2d0b2adce0f26bedd81ab0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/srnnkls/phora/releases/download/v0.3.3/phora-x86_64-apple-darwin.tar.xz"
      sha256 "fa89cd0590e6ed3b532490203b4b857f47a0befe106f685aee9c9a296114d02c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/srnnkls/phora/releases/download/v0.3.3/phora-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "25a7265507ffd2bdd295d3680c261af5c63c42fb8c37291c15330063039159da"
    end
    if Hardware::CPU.intel?
      url "https://github.com/srnnkls/phora/releases/download/v0.3.3/phora-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0396a22c9989cd9de0a4b21416d75b1a02507c69eac5a36cf7c4c30e6307b24e"
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
