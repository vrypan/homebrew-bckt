class Bckt < Formula
  desc "bckt is an opinionated but flexible static site generator for blogs"
  homepage "https://github.com/vrypan/bckt"
  version "0.6.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/vrypan/bckt/releases/download/v0.6.0/bckt-aarch64-apple-darwin.tar.xz"
    sha256 "7f843bb83c33948ce2b76b73464680d19893eb9cd13fc6b683785b717c58ca4e"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/vrypan/bckt/releases/download/v0.6.0/bckt-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "24fce788c211f686d813880b033ef8b0a2f4041c92673d2a9ba387c9e9a27b96"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vrypan/bckt/releases/download/v0.6.0/bckt-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "dd75695224677b330cf14af2d49b2351faac75fc016a76d7214b4f76ff3f373c"
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
