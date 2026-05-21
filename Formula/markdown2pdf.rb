class Markdown2pdf < Formula
  desc "Create PDF with Markdown files (a md to pdf transpiler)"
  homepage "https://github.com/theiskaa/markdown2pdf"
  version "1.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/theiskaa/markdown2pdf/releases/download/v1.3.0/markdown2pdf-aarch64-apple-darwin.tar.xz"
      sha256 "bf520855fe06881f9d1dc6fd01e19655c8421195b4712f8b244b8419d0b68967"
    end
    if Hardware::CPU.intel?
      url "https://github.com/theiskaa/markdown2pdf/releases/download/v1.3.0/markdown2pdf-x86_64-apple-darwin.tar.xz"
      sha256 "d68fb8608bf7e58aa8f295d1f892e49ef321c19de8ddce32c586c7604eedb301"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/theiskaa/markdown2pdf/releases/download/v1.3.0/markdown2pdf-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "eaa5fe2f5b630bac686c3acbd90605104bfcff78ef3008fb69e319624fd5b12c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/theiskaa/markdown2pdf/releases/download/v1.3.0/markdown2pdf-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "764c851058c00a7c5d2d15ff91ca9974c0ddad6654d037303fdb668fc5225205"
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
