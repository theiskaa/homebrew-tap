class Hedos < Formula
  desc "Discover, install, and serve the local models already on your machine."
  homepage "https://hedos.ai"
  version "1.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/theiskaa/hedos/releases/download/v1.2.1/hedos-aarch64-apple-darwin.tar.xz"
      sha256 "2d98d25fba2a97fdd69af7c987b444d760f6825fa383d8dde26cbb2b652e265c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/theiskaa/hedos/releases/download/v1.2.1/hedos-x86_64-apple-darwin.tar.xz"
      sha256 "b91a6b502d0c79637afb84d810319049f6a3684241af18b5fbcaeb542a8983c2"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/theiskaa/hedos/releases/download/v1.2.1/hedos-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "647f2834c22cf517e1104cae201f52a89dc27ef8b739d6b73d19a63dc16d4a16"
    end
    if Hardware::CPU.intel?
      url "https://github.com/theiskaa/hedos/releases/download/v1.2.1/hedos-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "18740b4145de5d4f8f96d3f2a0e5ee81839187f9e710becdf55d10a87fd9206e"
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
