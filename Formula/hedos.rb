class Hedos < Formula
  desc "Discover, install, and serve the local models already on your machine."
  homepage "https://hedos.ai"
  version "1.5.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/theiskaa/hedos/releases/download/v1.5.2/hedos-aarch64-apple-darwin.tar.xz"
      sha256 "562fe8181e10f3f47d638f29ba930d365561db07481d7e31d4c9f6a633e42eaf"
    end
    if Hardware::CPU.intel?
      url "https://github.com/theiskaa/hedos/releases/download/v1.5.2/hedos-x86_64-apple-darwin.tar.xz"
      sha256 "85f6ce38507f62c34ea86cfdf309c1be4e0b3ff9db73e333cc410e9d3d4ad0c8"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/theiskaa/hedos/releases/download/v1.5.2/hedos-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0f52f6b5300bcbd475c956d0fd956446f32ccc9fd46087ea9148a721a15bbc6f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/theiskaa/hedos/releases/download/v1.5.2/hedos-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7b96343ca54baa0f3b0e7b3b6182f0c2cff883602e063a8b739cc8bbeacd53e2"
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
