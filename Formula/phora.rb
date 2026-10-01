class Phora < Formula
  desc "A git-based artifact package manager and multiplexer for content-addressed file distribution"
  homepage "https://github.com/srnnkls/phora"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/srnnkls/phora/releases/download/v0.4.0/phora-aarch64-apple-darwin.tar.xz"
      sha256 "6623dc43cbc9d521ca3dfef88e92931576ab24969ce14765d86dd6e072bd869e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/srnnkls/phora/releases/download/v0.4.0/phora-x86_64-apple-darwin.tar.xz"
      sha256 "bf83926b177dfa7bea02f0ed1098e04ec0455b48c9687376291d403a7dcf41c7"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/srnnkls/phora/releases/download/v0.4.0/phora-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b02d5f6dac7f6878d0b0b8e077fd8998c1c5a8cfd18f2b7e84b3eebad6e0aa77"
    end
    if Hardware::CPU.intel?
      url "https://github.com/srnnkls/phora/releases/download/v0.4.0/phora-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3fbfccf5d3e543a96c4bb1e541696c48aa59ddb10ffe53a7f7018629a80b253a"
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
