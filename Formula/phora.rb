class Phora < Formula
  desc "A git-based artifact package manager and multiplexer for content-addressed file distribution"
  homepage "https://github.com/srnnkls/phora"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/srnnkls/phora/releases/download/v0.1.1/phora-aarch64-apple-darwin.tar.xz"
      sha256 "062c0d7aa9816950ce214bc0ec3bb4a1bb7b44639ec75843dfd3e927035da6e3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/srnnkls/phora/releases/download/v0.1.1/phora-x86_64-apple-darwin.tar.xz"
      sha256 "6ee8d01ec51bc7de24221ea4f9c95053704828bf9653d08a0a3967117e3a2c51"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/srnnkls/phora/releases/download/v0.1.1/phora-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d10a680d25e4018f91b06a5c7c2d4517d1738ce89d71afedbf8164fb7e2fb310"
    end
    if Hardware::CPU.intel?
      url "https://github.com/srnnkls/phora/releases/download/v0.1.1/phora-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d94d48c036b5b62938f58ed5b1d955bc023f79d8814c1014ebd19110f37bfe94"
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
