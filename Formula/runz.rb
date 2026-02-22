class Runz < Formula
  desc "A minimal, fast task runner"
  homepage "https://github.com/mfyuu/runz"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mfyuu/runz/releases/download/v0.1.3/runz-aarch64-apple-darwin.tar.xz"
      sha256 "f17ea3dc5ada0981544ee516a26f2d1e078f2130e061e72c77d2a8ed206a3a4e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mfyuu/runz/releases/download/v0.1.3/runz-x86_64-apple-darwin.tar.xz"
      sha256 "17c87dae48fe7b966aa60e5ff338e15859ae16864bbe1f6e8886df8d116e8765"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/mfyuu/runz/releases/download/v0.1.3/runz-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b91f364f0c474dc75d96a3979043b4057d0648827a5b5e40663cc6f1eda372ec"
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
