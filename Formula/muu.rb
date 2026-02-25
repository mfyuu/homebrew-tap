class Muu < Formula
  desc "A minimal, fast task runner"
  homepage "https://github.com/mfyuu/muu"
  version "0.3.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mfyuu/muu/releases/download/v0.3.2/muu-aarch64-apple-darwin.tar.xz"
      sha256 "dd8a3fed9d5afe8ae06c843c50292fe602d392628cf573d77cda3eaf2162dc0e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mfyuu/muu/releases/download/v0.3.2/muu-x86_64-apple-darwin.tar.xz"
      sha256 "c51e8404e5d8713a2e61283d4d3bb4506c433bb5acd13e9fad8963ce7ff6d411"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/mfyuu/muu/releases/download/v0.3.2/muu-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "241c7d1820b78a8fe20d91b668748f5dbae5362abcded4861281c5733e87f57b"
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
