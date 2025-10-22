class Bckt < Formula
  desc "bckt is an opinionated but flexible static site generator for blogs"
  homepage "https://github.com/vrypan/bckt"
  version "0.6.1"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/vrypan/bckt/releases/download/v0.6.1/bckt-aarch64-apple-darwin.tar.xz"
    sha256 "8f48d16a7ab402b9eee7abf10083f7ed259cf665ecc076df23c6a8dc60e95d1e"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/vrypan/bckt/releases/download/v0.6.1/bckt-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "96fa4821dfcef12320e142611c1e3fae974c02bbe4da824c74c314a446751540"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vrypan/bckt/releases/download/v0.6.1/bckt-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9a31f2ba98c97f1b81adf6b0d1d38eb0375b66db568941e9961e5e1ba2cd791d"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
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
    bin.install "bckt", "bckt-fc", "bckt-new" if OS.mac? && Hardware::CPU.arm?
    bin.install "bckt", "bckt-fc", "bckt-new" if OS.linux? && Hardware::CPU.arm?
    bin.install "bckt", "bckt-fc", "bckt-new" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
