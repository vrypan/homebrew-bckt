class Bckt < Formula
  desc "bckt is an opinionated but flexible static site generator for blogs"
  homepage "https://github.com/vrypan/bckt"
  version "0.5.3"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/vrypan/bckt/releases/download/v0.5.3/bckt-aarch64-apple-darwin.tar.xz"
    sha256 "2ba3a186388aa3a41300290c6047691ce9c421b7f429e7e9538c82afdde1a52c"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/vrypan/bckt/releases/download/v0.5.3/bckt-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d3a5d72e7388acadb0b2ed04fc0dc295350fe2e1b20e290aba782bc4496fa34a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vrypan/bckt/releases/download/v0.5.3/bckt-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "01582fb2a0eefff7ca900b4e0ef3fd12bc431334a1780cc759fd1e2acd35a57a"
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
