class Muu < Formula
  desc "A minimal, fast task runner"
  homepage "https://github.com/mfyuu/muu"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mfyuu/muu/releases/download/v0.3.0/muu-aarch64-apple-darwin.tar.xz"
      sha256 "a41b1a912b95c10598f0a2282267f4177c76697971f2cb005b4750a17a802e5d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mfyuu/muu/releases/download/v0.3.0/muu-x86_64-apple-darwin.tar.xz"
      sha256 "5b0520f66f05399e164ecb0a454522796226fd35d8a4b9bc995545e0403ab106"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/mfyuu/muu/releases/download/v0.3.0/muu-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "67452e0df5906410228cdd78e1d1a8ed48b5903167eac6e5fdb22dee93b3c9a3"
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
