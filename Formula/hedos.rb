class Hedos < Formula
  desc "Discover, install, and serve the local models already on your machine."
  homepage "https://hedos.ai"
  version "1.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/theiskaa/hedos/releases/download/v1.2.0/hedos-aarch64-apple-darwin.tar.xz"
      sha256 "a3910804b5c1cf0c92825c2c93ae3f0fbadf75af1f9b8e5071a97c30e59f0c12"
    end
    if Hardware::CPU.intel?
      url "https://github.com/theiskaa/hedos/releases/download/v1.2.0/hedos-x86_64-apple-darwin.tar.xz"
      sha256 "3d0a26c953c604f2911c37ccf9ede7f0bf91739a45624a588d541021085e1f80"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/theiskaa/hedos/releases/download/v1.2.0/hedos-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "460ba117d9cb024dbbeaf4c853fbef95f61171d4e5fc8e82d54f001aa05a4bce"
    end
    if Hardware::CPU.intel?
      url "https://github.com/theiskaa/hedos/releases/download/v1.2.0/hedos-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "54b1b2946257db2a2cbc98ce82b06f5a93450cb96ff5eb75f80682d68d88ea21"
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
