class Bckt < Formula
  desc "bckt is an opinionated but flexible static site generator for blogs"
  homepage "https://github.com/vrypan/bckt"
  version "0.5.2"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/vrypan/bckt/releases/download/v0.5.2/bckt-aarch64-apple-darwin.tar.xz"
    sha256 "edf4d1add48c536019eecc47c34cb538be73ef41a340438d1a038e4fe9b2b4d6"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/vrypan/bckt/releases/download/v0.5.2/bckt-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2fcc2645670bebf00408abc713edebfcf38f01a6f932766d2baa47ae54f7e142"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vrypan/bckt/releases/download/v0.5.2/bckt-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "37b04deea61eba999842c62a7d813d7f6fef2734f9e5e8ad22cd1fdefe442454"
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
