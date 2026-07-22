class Hedos < Formula
  desc "Discover, install, and serve the local models already on your machine."
  homepage "https://hedos.ai"
  version "1.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/theiskaa/hedos/releases/download/v1.1.1/hedos-aarch64-apple-darwin.tar.xz"
      sha256 "d00672f3213256c0005fe1ae0f887fe3fda01ab54f925b09b3714f462ba4edf3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/theiskaa/hedos/releases/download/v1.1.1/hedos-x86_64-apple-darwin.tar.xz"
      sha256 "25140403b4ace019867c930ea6dfac75489aba40945b25cf6df72c81ead62ac2"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/theiskaa/hedos/releases/download/v1.1.1/hedos-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c47f3dce1a304749c6476f9d301b9871b42c87b71c3c68dd6ea7d4355077653d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/theiskaa/hedos/releases/download/v1.1.1/hedos-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2335a742efd53f3749d35851c45e8a56dc4ff1c1d655ee6667a1717cddeb043a"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
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
    bin.install "hedos" if OS.mac? && Hardware::CPU.arm?
    bin.install "hedos" if OS.mac? && Hardware::CPU.intel?
    bin.install "hedos" if OS.linux? && Hardware::CPU.arm?
    bin.install "hedos" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
