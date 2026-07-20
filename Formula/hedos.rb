class Hedos < Formula
  desc "Discover, install, and serve the local models already on your machine."
  homepage "https://hedos.ai"
  version "1.0.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/theiskaa/hedos/releases/download/v1.0.0/hedos-aarch64-apple-darwin.tar.xz"
      sha256 "e8b282734ac32f061322dfe1a10bb9e7143ea40520bf8c3ab88dda1ebfabd9ac"
    end
    if Hardware::CPU.intel?
      url "https://github.com/theiskaa/hedos/releases/download/v1.0.0/hedos-x86_64-apple-darwin.tar.xz"
      sha256 "794638c62ab3a1b903f18cc06622fc5d86d16c85a00df44a56cb33eeeef0cd3d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/theiskaa/hedos/releases/download/v1.0.0/hedos-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "58f7409af77eb46debc446fb4a433fe1cd8569e600bf222ada176cc45e39489b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/theiskaa/hedos/releases/download/v1.0.0/hedos-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "62a86c5cbc2367d8a2b600b7f6bf13d343ff77d034d6cc18718ac5d47f4e52f7"
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
