class Phora < Formula
  desc "A git-based artifact package manager and multiplexer for content-addressed file distribution"
  homepage "https://github.com/srnnkls/phora"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/srnnkls/phora/releases/download/v0.2.0/phora-aarch64-apple-darwin.tar.xz"
      sha256 "a7e6c710e89557400eed02db6934c65f1451e7184c841575fff0c0704c7ca4c9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/srnnkls/phora/releases/download/v0.2.0/phora-x86_64-apple-darwin.tar.xz"
      sha256 "206d663d996e1cc180f7a590d998c7099230084116467c656448daa802440a9b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/srnnkls/phora/releases/download/v0.2.0/phora-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b88b1cf079fcf7ec52174a4c5d5014fa1250e7e791de93ca20eefba17d01dfde"
    end
    if Hardware::CPU.intel?
      url "https://github.com/srnnkls/phora/releases/download/v0.2.0/phora-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7d63a05327b4bcb45c8d205a0b63eb20c7822fbddf4e9b92c238209381be7eb6"
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
