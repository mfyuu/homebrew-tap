class Muu < Formula
  desc "A minimal, fast task runner"
  homepage "https://github.com/mfyuu/muu"
  version "0.3.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mfyuu/muu/releases/download/v0.3.1/muu-aarch64-apple-darwin.tar.xz"
      sha256 "c82c8bb44fe0a3688082f1807bb01d84f54b162c855747ccbb9a0a499616bea8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mfyuu/muu/releases/download/v0.3.1/muu-x86_64-apple-darwin.tar.xz"
      sha256 "bec16410f93f8556a5cce3f1ccd41ad4be552c82035d6bc5d454c8695a407fe5"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/mfyuu/muu/releases/download/v0.3.1/muu-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9a3e8493358d983938a7c1a440931a9edc15993d6d006c29ed8f60601e97fd26"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-pc-windows-gnu":    {},
    "x86_64-unknown-linux-gnu": {},
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
    bin.install "muu" if OS.mac? && Hardware::CPU.arm?
    bin.install "muu" if OS.mac? && Hardware::CPU.intel?
    bin.install "muu" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
