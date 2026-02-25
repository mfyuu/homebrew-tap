class Muu < Formula
  desc "A minimal, fast task runner"
  homepage "https://github.com/mfyuu/muu"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mfyuu/muu/releases/download/v0.4.0/muu-aarch64-apple-darwin.tar.xz"
      sha256 "4f0f212bcb6488762d521f7eb59a799322e038a060632341074e8ce211a95648"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mfyuu/muu/releases/download/v0.4.0/muu-x86_64-apple-darwin.tar.xz"
      sha256 "fab15eb07287f722f9723ef11f8c4a2c66bff072552f935d8962aa1bb3bc4fcd"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/mfyuu/muu/releases/download/v0.4.0/muu-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "13413bde280841d10e6adc8b3fb3f35d815b69d2d467a5c5396bc9640adf8bd7"
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
