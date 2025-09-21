class Markdown2pdf < Formula
  desc "Create PDF with Markdown files (a md to pdf transpiler)"
  homepage "https://github.com/theiskaa/markdown2pdf"
  version "0.1.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/theiskaa/markdown2pdf/releases/download/v0.1.7/markdown2pdf-aarch64-apple-darwin.tar.xz"
      sha256 "112e8fd48a9334912828f8dcf77663afd792c8fb9a57e6843154cbd3c1264018"
    end
    if Hardware::CPU.intel?
      url "https://github.com/theiskaa/markdown2pdf/releases/download/v0.1.7/markdown2pdf-x86_64-apple-darwin.tar.xz"
      sha256 "fdde26fab48fa6d76bd4f80125c89170d656da62ee50b2f556e572694223d57a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/theiskaa/markdown2pdf/releases/download/v0.1.7/markdown2pdf-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "424854653c195668fa0d759a5394c267aa0d73dd0599ef76b47b85009f74a3e9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/theiskaa/markdown2pdf/releases/download/v0.1.7/markdown2pdf-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ddb9af3ab449d66e6f93f4513c9641aabe89644ee0431b25419ddcd1e0828f75"
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
