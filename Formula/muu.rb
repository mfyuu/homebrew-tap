class Muu < Formula
  desc "A minimal, fast task runner"
  homepage "https://github.com/mfyuu/muu"
  version "0.4.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mfyuu/muu/releases/download/v0.4.1/muu-aarch64-apple-darwin.tar.xz"
      sha256 "8520015292b8e398c1b3eee15cf7a9bca2b8e7e0232352dc12e688ba6c86b193"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mfyuu/muu/releases/download/v0.4.1/muu-x86_64-apple-darwin.tar.xz"
      sha256 "3bef3cc50bce88ee40956b8aa15ee83c9d737e5a4ec278387eb73f85d33eb9f5"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/mfyuu/muu/releases/download/v0.4.1/muu-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "fa36b3aef693d1a6353cbd7cd7d7c61b1b3d9ee221187bb1aa5f42ed6d95d686"
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
