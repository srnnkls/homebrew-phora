class Phora < Formula
  desc "A git-based artifact package manager and multiplexer for content-addressed file distribution"
  homepage "https://github.com/srnnkls/phora"
  version "0.4.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/srnnkls/phora/releases/download/v0.4.1/phora-aarch64-apple-darwin.tar.xz"
      sha256 "a40338104c4277f22c3eaed07e099ad1f0c2f8e627c98dbdd806e9c33b73e189"
    end
    if Hardware::CPU.intel?
      url "https://github.com/srnnkls/phora/releases/download/v0.4.1/phora-x86_64-apple-darwin.tar.xz"
      sha256 "83facd6174bf752e6fcc4c85bafde1ebc0c27b4b558107924b50dc2821ed132d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/srnnkls/phora/releases/download/v0.4.1/phora-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d4099c9243aa5fce5e7f6f60e625c18f2bc8f70f0e94b23f6184a38973be5019"
    end
    if Hardware::CPU.intel?
      url "https://github.com/srnnkls/phora/releases/download/v0.4.1/phora-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a8a7507a061fba97c915997c73a60afb55c4c1e2ef6a98619be5f25cecfceb17"
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
