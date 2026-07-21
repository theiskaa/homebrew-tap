class Hedos < Formula
  desc "Discover, install, and serve the local models already on your machine."
  homepage "https://hedos.ai"
  version "1.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/theiskaa/hedos/releases/download/v1.1.0/hedos-aarch64-apple-darwin.tar.xz"
      sha256 "2594cc5abd2272db5678de7796f64fac701300932328ae38243d1af3854a0e1b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/theiskaa/hedos/releases/download/v1.1.0/hedos-x86_64-apple-darwin.tar.xz"
      sha256 "4c7c9b1ec6cf39d8a3cc8d2a35411e59e3010428ec3998933341310196c63d46"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/theiskaa/hedos/releases/download/v1.1.0/hedos-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4c8f822a10e90ba6d778b7f9de4af135073d6882b1015eb8c493b941913cb6ac"
    end
    if Hardware::CPU.intel?
      url "https://github.com/theiskaa/hedos/releases/download/v1.1.0/hedos-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3370d0663694e1abbed11871dcf58ffc9944fcc06506897c7dd4924a423bca45"
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
