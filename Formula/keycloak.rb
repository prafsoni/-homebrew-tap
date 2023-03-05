# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Keycloak < Formula
  desc "Open Source Identity and Access Management"
  homepage "https://www.keycloak.org/"
  url "https://github.com/keycloak/keycloak/releases/download/21.0.1/keycloak-21.0.1.tar.gz"
  #version "21.0.1"
  sha256 "6463fdb9540c2862c112d2a291ed301089220680991ce9b28549f875e4ee1443"
  license "Apache-2.0"

  # depends_on "cmake" => :build

  def install
    # ENV.deparallelize  # if your formula fails when building in parallel
    # Remove unrecognized options if warned by configure
    # https://rubydoc.brew.sh/Formula.html#std_configure_args-instance_method
    #system "./configure", *std_configure_args, "--disable-silent-rules"
    # system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    libexec.install "bin", "conf", "lib" #, "providers", "themes" 

    # Move config files into etc
    (etc/"keycloak").install Dir[libexec/"conf/*"]
    (libexec/"conf").rmtree
    
    # for client jars
    # Dir.foreach(libexec/"bin") do |f|
    #     next if f == "." || f == ".." || !File.extname(f).empty?
  
    #     bin.install libexec/"bin"/f
    # end
    # for .sh
    Dir.foreach(libexec/"bin") do |f|
        next if f == "." || f == ".." || File.extname(f) != ".sh"
  
        bin.install libexec/"bin"/f
    end
    bin.env_script_all_files(libexec/"bin", {})
    

  end

  def post_install
    # Make sure runtime directories exist
    (var/"lib/keycloak").mkpath
    (var/"lib/keycloak/data").mkpath
    ln_s var/"lib/keycloak/data", libexec/"data"
    (var/"log/keycloak").mkpath
    ln_s etc/"keycloak", libexec/"conf"
    (var/"keycloak/providers").mkpath
    ln_s var/"keycloak/providers", libexec/"providers"
    (var/"keycloak/themes").mkpath
    ln_s var/"keycloak/themes", libexec/"themes"
  end

  def caveats
    s = <<~EOS
      Data:    #{var}/lib/keycloak/data/
      Logs:    #{var}/log/keycloak/keycloak.log
      Providers: #{var}/keycloak/providers/
      Config:  #{etc}/keycloak/
      Themes: #{var}/keycloak/themes/
    EOS

    s
  end

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>KeepAlive</key>
          <false/>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/kc.sh</string>
            <string>start-dev</string>
          </array>
          <key>EnvironmentVariables</key>
          <dict>
          </dict>
          <key>RunAtLoad</key>
          <true/>
          <key>WorkingDirectory</key>
          <string>#{var}</string>
          <key>StandardErrorPath</key>
          <string>#{var}/log/keycloak/keycloak.log</string>
          <key>StandardOutPath</key>
          <string>#{var}/log/keycloak/keycloak.log</string>
        </dict>
      </plist>
    EOS
  end

  # TODO :// add test
  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test keycloak`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end
