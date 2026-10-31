class Hedos < Formula
  desc "Discover, install, and serve the local models already on your machine."
  homepage "https://hedos.ai"
  version "1.6.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/theiskaa/hedos/releases/download/v1.6.0/hedos-aarch64-apple-darwin.tar.xz"
      sha256 "62c617b2903a296c7ff5a047411107d9e2e7a8491870595e7c114ab567621258"
    end
    if Hardware::CPU.intel?
      url "https://github.com/theiskaa/hedos/releases/download/v1.6.0/hedos-x86_64-apple-darwin.tar.xz"
      sha256 "920a78fc3d0aac5850167e3856bd6b7b580259fce1af5a388692a8e8d5cfcaf2"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/theiskaa/hedos/releases/download/v1.6.0/hedos-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "9ef030ea9ebcc1c93999ae94b0cb76cdfa887bdf9cc2afbd624b9626a13a951a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/theiskaa/hedos/releases/download/v1.6.0/hedos-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "abcbb8abcfa267cab6c2f6be782d9a365639818e1798b8aac86a569d582dc442"
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
