class Hedos < Formula
  desc "Discover, install, and serve the local models already on your machine."
  homepage "https://hedos.ai"
  version "1.4.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/theiskaa/hedos/releases/download/v1.4.3/hedos-aarch64-apple-darwin.tar.xz"
      sha256 "c2790d8dff0a8d1f7c7c66286e869bb369a0b88e3893fdfe43e9e7c3ac21959c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/theiskaa/hedos/releases/download/v1.4.3/hedos-x86_64-apple-darwin.tar.xz"
      sha256 "0b59c7ea0fb8a292078f1d476481b25b89c359fbaa817baf03eaf0239d22a546"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/theiskaa/hedos/releases/download/v1.4.3/hedos-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b2abefb1439788299e352235689237830101708cb9af9f9570a412056d8bdf09"
    end
    if Hardware::CPU.intel?
      url "https://github.com/theiskaa/hedos/releases/download/v1.4.3/hedos-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9c3d8ee3d35d042922ce4044f388fea8ea4253662df78c583954ab0595ab93b2"
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
