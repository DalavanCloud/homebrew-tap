class Mas < Formula
  desc "Mac App Store command-line interface"
  homepage "https://github.com/mas-cli/mas"
  url "https://github.com/mas-cli/mas.git",
      :tag      => "v1.5.0",
      :revision => "ccaaa74c9593d04dc41fcff40af196fdad49f517"
  head "https://github.com/mas-cli/mas.git"

  bottle do
    root_url "https://dl.bintray.com/phatblat/mas-bottles"
    cellar :any
    sha256 "e12ef9a1351214e59011326b913d03800fa5c5e07b50681051e50dc98fa2d05a" => :mojave
    sha256 "e12ef9a1351214e59011326b913d03800fa5c5e07b50681051e50dc98fa2d05a" => :high_sierra
    sha256 "e12ef9a1351214e59011326b913d03800fa5c5e07b50681051e50dc98fa2d05a" => :sierra
    sha256 "e12ef9a1351214e59011326b913d03800fa5c5e07b50681051e50dc98fa2d05a" => :el_capitan
  end

  depends_on "carthage" => :build
  depends_on :xcode => ["10.1", :build]
  depends_on "trash"

  def install
    # Working around build issues in dependencies
    # - Prevent warnings from causing build failures
    # - Prevent linker errors by telling all lib builds to use max size install names
    xcconfig = buildpath/"Overrides.xcconfig"
    xcconfig.write <<~EOS
      GCC_TREAT_WARNINGS_AS_ERRORS = NO
      OTHER_LDFLAGS = -headerpad_max_install_names
    EOS
    ENV["XCODE_XCCONFIG_FILE"] = xcconfig

    system "carthage", "bootstrap", "--platform", "macOS"
    system "script/install", prefix

    bash_completion.install "contrib/completion/mas-completion.bash" => "mas"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/mas version").chomp
  end
end
