class Runz < Formula
  desc "A minimal, fast task runner"
  homepage "https://github.com/mfyuu/runz"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mfyuu/runz/releases/download/v0.1.2/runz-aarch64-apple-darwin.tar.xz"
      sha256 "12260ffce5886a12bdf2f622d9100ab7dc9719df2f79b78c6e556f9a99d7b115"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mfyuu/runz/releases/download/v0.1.2/runz-x86_64-apple-darwin.tar.xz"
      sha256 "79789cae40aedf7e8dc45c3f3e9bdccba5e655c85090f49eeb8aec796983baa3"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/mfyuu/runz/releases/download/v0.1.2/runz-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "fb4730a65fa0f6a38bc867c219ee30d9cb389964ff148d4c7fc2e74ba187c948"
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
    bin.install "runz" if OS.mac? && Hardware::CPU.arm?
    bin.install "runz" if OS.mac? && Hardware::CPU.intel?
    bin.install "runz" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
