class Sqlcmd < Formula
  desc "Microsoft SQL Server command-line interface"
  homepage "https://github.com/microsoft/go-sqlcmd"
  url "https://github.com/microsoft/go-sqlcmd.git",
  tag:      "v0.8.1",
  revision: "4e0b95ce49b8164c6496ca1b7a85fa57734fef4c"
  license "MIT"

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/sqlcmd"
  end

  test do
    out = shell_output("#{bin}/sqlcmd -S 127.0.0.1 -E -Q 'SELECT @@version'", 1)
    assert_match "unable to open tcp connection with host '127.0.0.1:1433': " \
                 "dial tcp 127.0.0.1:1433: connect: connection refused", out
  end
end
