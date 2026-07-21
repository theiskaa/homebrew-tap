class Markdown2pdf < Formula
  desc "Create PDF with Markdown files (a md to pdf transpiler)"
  homepage "https://github.com/theiskaa/markdown2pdf"
  version "1.6.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/theiskaa/markdown2pdf/releases/download/v1.6.0/markdown2pdf-aarch64-apple-darwin.tar.xz"
      sha256 "94f6b83fd259121efb0ceebe7175815f562e1d7a4344ba94cb085689f78f2978"
    end
    if Hardware::CPU.intel?
      url "https://github.com/theiskaa/markdown2pdf/releases/download/v1.6.0/markdown2pdf-x86_64-apple-darwin.tar.xz"
      sha256 "90ccc80bf890300b3635b396622a46a405713d4045b13362ccdcc83b0a0192c7"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/theiskaa/markdown2pdf/releases/download/v1.6.0/markdown2pdf-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ada9949308f65310e0abba141a6a3ffb85deea2339e5d072e8f0b2862dd7ba0b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/theiskaa/markdown2pdf/releases/download/v1.6.0/markdown2pdf-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "34d2b90e36306a49992c59684e03a8c445f7c162568051aafa87003329f05e1e"
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
