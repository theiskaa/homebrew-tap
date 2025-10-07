class Markdown2pdf < Formula
  desc "Create PDF with Markdown files (a md to pdf transpiler)"
  homepage "https://github.com/theiskaa/markdown2pdf"
  version "0.1.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/theiskaa/markdown2pdf/releases/download/v0.1.8/markdown2pdf-aarch64-apple-darwin.tar.xz"
      sha256 "7757ebb14f1bac273d6be2edfb3f03d5cbf3ec909dab8572a39018fd899f5755"
    end
    if Hardware::CPU.intel?
      url "https://github.com/theiskaa/markdown2pdf/releases/download/v0.1.8/markdown2pdf-x86_64-apple-darwin.tar.xz"
      sha256 "f54d4e6d200bced48bbfd1fc468501a246a5b60d5f6071bbd5a9cc3e6b49c494"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/theiskaa/markdown2pdf/releases/download/v0.1.8/markdown2pdf-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d38c7cfd4b4113e0fa25d69034b5f514cd954e77cfcc8ea631c59028145d5a7a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/theiskaa/markdown2pdf/releases/download/v0.1.8/markdown2pdf-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "788a95183720e230978d359e8d7b2d46ca4c45873f66526255d3c92b2e049885"
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
