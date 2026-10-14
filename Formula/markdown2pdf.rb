class Markdown2pdf < Formula
  desc "Create PDF with Markdown files (a md to pdf transpiler)"
  homepage "https://github.com/theiskaa/markdown2pdf"
  version "1.6.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/theiskaa/markdown2pdf/releases/download/v1.6.2/markdown2pdf-aarch64-apple-darwin.tar.xz"
      sha256 "77a7e2e7decad1f59a6a86b3b3ab7b2cd5a8332dab33d479245a6af8afebd169"
    end
    if Hardware::CPU.intel?
      url "https://github.com/theiskaa/markdown2pdf/releases/download/v1.6.2/markdown2pdf-x86_64-apple-darwin.tar.xz"
      sha256 "faa7241a8e54fb74fd3b5069749aea2b6383f2d4ddb833fa08630db1bb83ff25"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/theiskaa/markdown2pdf/releases/download/v1.6.2/markdown2pdf-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "101d54911d83096709e5abecde0557c2bee2e4644cded7aa8a7292007a52a6ee"
    end
    if Hardware::CPU.intel?
      url "https://github.com/theiskaa/markdown2pdf/releases/download/v1.6.2/markdown2pdf-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ab7fe0e38cfc1fcf8637b18da01f49097c9c99f20c4dac08bb014f16be150de4"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "markdown2pdf"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "markdown2pdf"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "markdown2pdf"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "markdown2pdf"
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
