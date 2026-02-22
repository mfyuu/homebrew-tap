class Runz < Formula
  desc "A minimal, fast task runner"
  homepage "https://github.com/mfyuu/runz"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mfyuu/runz/releases/download/v0.1.1/runz-aarch64-apple-darwin.tar.xz"
      sha256 "a4ffa4b2d4f5411caab8ecc4abfd87d1e880568593c791023d8e830d2a4dc108"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mfyuu/runz/releases/download/v0.1.1/runz-x86_64-apple-darwin.tar.xz"
      sha256 "f1658e6bac3b4477748da349c1453726f5af640662b6fbef5c0a0b9f7e1c568c"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/mfyuu/runz/releases/download/v0.1.1/runz-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c23c260d0635ce656a5c45a42138dc21384cc805b76e28ef7c1d74894d6c670c"
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
