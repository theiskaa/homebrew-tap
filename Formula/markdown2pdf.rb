class Markdown2pdf < Formula
  desc "Create PDF with Markdown files (a md to pdf transpiler)"
  homepage "https://github.com/theiskaa/markdown2pdf"
  version "1.6.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/theiskaa/markdown2pdf/releases/download/v1.6.1/markdown2pdf-aarch64-apple-darwin.tar.xz"
      sha256 "122029497b1529e3d7269db68d463a077b69ebdca649093f4971e6be7cec74b6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/theiskaa/markdown2pdf/releases/download/v1.6.1/markdown2pdf-x86_64-apple-darwin.tar.xz"
      sha256 "38cef8283f01d4e7cd3193e8a5f0c3b451903810b58c96eaca38e540781b4e09"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/theiskaa/markdown2pdf/releases/download/v1.6.1/markdown2pdf-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a5d05fc119178cd5abb46221f4a81973fb9e3ddcd1f5d08cd933efb3b70b7e83"
    end
    if Hardware::CPU.intel?
      url "https://github.com/theiskaa/markdown2pdf/releases/download/v1.6.1/markdown2pdf-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7e1e3943a1b3ac93fb39f8e6155e8a9d739876fe35ed27c034ddb646aef406c5"
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
