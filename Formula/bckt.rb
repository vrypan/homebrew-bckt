class Bckt < Formula
  desc "bckt is an opinionated but flexible static site generator for blogs"
  homepage "https://github.com/vrypan/bckt"
  version "0.2.6"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/vrypan/bckt/releases/download/v0.2.6/bckt-aarch64-apple-darwin.tar.xz"
    sha256 "2cde0b57e690cc4440892ced38055f91269d17acf7ef7f72aa6888323eec47d5"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/vrypan/bckt/releases/download/v0.2.6/bckt-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "aeaf14a33e26566313c2060e3263625dddef3bf9cce3d9ccc47c81dd3f36aaf4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vrypan/bckt/releases/download/v0.2.6/bckt-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "90cea7ec21dc24b28e4f774113fd32724ab1a6909d35080b7852dadb50101c84"
    end
  end

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
    bin.install "bckt", "bckt-fc" if OS.mac? && Hardware::CPU.arm?
    bin.install "bckt", "bckt-fc" if OS.linux? && Hardware::CPU.arm?
    bin.install "bckt", "bckt-fc" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
