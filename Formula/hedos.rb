class Hedos < Formula
  desc "Discover, install, and serve the local models already on your machine."
  homepage "https://hedos.ai"
  version "1.4.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/theiskaa/hedos/releases/download/v1.4.2/hedos-aarch64-apple-darwin.tar.xz"
      sha256 "d9f5f61248ece1ed58fc0ffaa85ac3b6c27077b657679ac068201b0ddb826305"
    end
    if Hardware::CPU.intel?
      url "https://github.com/theiskaa/hedos/releases/download/v1.4.2/hedos-x86_64-apple-darwin.tar.xz"
      sha256 "8e06cf6ebd655f215f0b59e0ed1409451dc5da1b9f765bbe607010df6e6268de"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/theiskaa/hedos/releases/download/v1.4.2/hedos-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0a6457e098e5916ab658d9cdce429f06c8ce3266d5a94d2b21485b7e11eed2a9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/theiskaa/hedos/releases/download/v1.4.2/hedos-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d694b78bcf6f8e6377e425cdbbb587606a18547b80c098f85c53ed4b17fe3141"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "hedos"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "hedos"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "hedos"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "hedos"
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
