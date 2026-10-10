class Hedos < Formula
  desc "Discover, install, and serve the local models already on your machine."
  homepage "https://hedos.ai"
  version "1.5.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/theiskaa/hedos/releases/download/v1.5.1/hedos-aarch64-apple-darwin.tar.xz"
      sha256 "f3be2cafda40d41c1983b9a2a56a859cdab422b615a693cd239043b723872f13"
    end
    if Hardware::CPU.intel?
      url "https://github.com/theiskaa/hedos/releases/download/v1.5.1/hedos-x86_64-apple-darwin.tar.xz"
      sha256 "1ac14484f818af91feb416ab8252e689990b514ed1a6e629fb87efa04ce9e248"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/theiskaa/hedos/releases/download/v1.5.1/hedos-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "bd18bb727bced8e731514e34537dd0a7dec8570c24cd39102a025457880139e2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/theiskaa/hedos/releases/download/v1.5.1/hedos-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0036ec3f8b243dd8fe0b023c6d98515cfe83023e50103441dc80ba9cd28ffa50"
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
