class Markdown2pdf < Formula
  desc "Create PDF with Markdown files (a md to pdf transpiler)"
  homepage "https://github.com/theiskaa/markdown2pdf"
  version "1.0.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/theiskaa/markdown2pdf/releases/download/v1.0.0/markdown2pdf-aarch64-apple-darwin.tar.xz"
      sha256 "aa54dc13063c4f6a158233ab3993565184a62f434a53afd291011c22dfc3995f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/theiskaa/markdown2pdf/releases/download/v1.0.0/markdown2pdf-x86_64-apple-darwin.tar.xz"
      sha256 "c7dd218ae8b9d31efcb9f239e89d13bcdb5c32ca0c93f91de207c2ff0ab6dda4"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/theiskaa/markdown2pdf/releases/download/v1.0.0/markdown2pdf-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5f205c44efbe5d336b1cd71b164b418f0ae4da3d831b08dfab469382df9af9e7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/theiskaa/markdown2pdf/releases/download/v1.0.0/markdown2pdf-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "658dc998ec73ed1f92087f168ba04e5823fc5a91f8b7afedd2886c55794f49eb"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
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
    bin.install "markdown2pdf" if OS.mac? && Hardware::CPU.arm?
    bin.install "markdown2pdf" if OS.mac? && Hardware::CPU.intel?
    bin.install "markdown2pdf" if OS.linux? && Hardware::CPU.arm?
    bin.install "markdown2pdf" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
