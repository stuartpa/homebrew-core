class Miniupnpc < Formula
  desc "UPnP IGD client library and daemon"
  homepage "https://miniupnp.tuxfamily.org"
  url "http://miniupnp.tuxfamily.org/files/download.php?file=miniupnpc-2.2.3.tar.gz"
  sha256 "dce41b4a4f08521c53a0ab163ad2007d18b5e1aa173ea5803bd47a1be3159c24"
  license "BSD-3-Clause"

  # We only match versions with only a major/minor since versions like 2.1 are
  # stable and versions like 2.1.20191224 are unstable/development releases.
  livecheck do
    url "https://miniupnp.tuxfamily.org/files/"
    regex(/href=.*?miniupnpc[._-]v?(\d+\.\d+(?>.\d{1,7})*)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_big_sur: "8895acaf9fa55bb5cd0f5feb6cd104512657494035ae1650a8b73dccdded5b0f"
    sha256 cellar: :any,                 big_sur:       "e1295aef25a9cfbcbbace72d1a2a76aff88c5334848b4ce2f88fde84a326ff62"
    sha256 cellar: :any,                 catalina:      "5b3510471e85184f82cb7bc594d819c6a303e44d2853b726c708c1b9b2fba245"
    sha256 cellar: :any,                 mojave:        "59b55d5ef7cb08a7ee55b6c06f7313b58ed520e4f84cf74ca77e6066c3e08d1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9b866d13fd88d34f1c0728cf08dc86556c473d42e486409ec1d95919db3659b"
  end

  # Fix missing references to $(BUILD) in the install rules
  # equivalent to https://github.com/miniupnp/miniupnp/commit/ed1dc4bb5cdc4a53963f3eb01089289e30acc5a3
  # but modified to start with the miniupnpc folder as root
  patch :DATA

  def install
    system "make", "INSTALLPREFIX=#{prefix}", "install"
  end

  test do
    output = shell_output("#{bin}/upnpc --help 2>&1", 1)
    assert_match version.to_s, output
  end
end

__END__
diff --git a/Makefile b/Makefile
index 4563b283..11a17f95 100644
--- a/Makefile
+++ b/Makefile
@@ -162,7 +162,7 @@ PKGCONFIGDIR = $(INSTALLDIRLIB)/pkgconfig
 
 FILESTOINSTALL = $(LIBRARY) $(EXECUTABLES)
 ifeq (, $(findstring amiga, $(OS)))
-FILESTOINSTALL += $(SHAREDLIBRARY) miniupnpc.pc
+FILESTOINSTALL += $(SHAREDLIBRARY) $(BUILD)/miniupnpc.pc
 endif
 
 
@@ -251,15 +251,15 @@ install:	updateversion $(FILESTOINSTALL)
 	$(INSTALL) -m 644 $(LIBRARY) $(DESTDIR)$(INSTALLDIRLIB)
 ifeq (, $(findstring amiga, $(OS)))
 	$(INSTALL) -m 644 $(SHAREDLIBRARY) $(DESTDIR)$(INSTALLDIRLIB)/$(SONAME)
-	ln -fs $(SONAME) $(DESTDIR)$(INSTALLDIRLIB)/$(SHAREDLIBRARY)
+	ln -fs $(SONAME) $(DESTDIR)$(INSTALLDIRLIB)/$(notdir $(SHAREDLIBRARY))
 	$(INSTALL) -d $(DESTDIR)$(PKGCONFIGDIR)
-	$(INSTALL) -m 644 miniupnpc.pc $(DESTDIR)$(PKGCONFIGDIR)
+	$(INSTALL) -m 644 $(BUILD)/miniupnpc.pc $(DESTDIR)$(PKGCONFIGDIR)
 endif
 	$(INSTALL) -d $(DESTDIR)$(INSTALLDIRBIN)
 ifneq (, $(findstring amiga, $(OS)))
-	$(INSTALL) -m 755 upnpc-static $(DESTDIR)$(INSTALLDIRBIN)/upnpc
+	$(INSTALL) -m 755 $(BUILD)/upnpc-static $(DESTDIR)$(INSTALLDIRBIN)/upnpc
 else
-	$(INSTALL) -m 755 upnpc-shared $(DESTDIR)$(INSTALLDIRBIN)/upnpc
+	$(INSTALL) -m 755 $(BUILD)/upnpc-shared $(DESTDIR)$(INSTALLDIRBIN)/upnpc
 endif
 	$(INSTALL) -m 755 external-ip.sh $(DESTDIR)$(INSTALLDIRBIN)/external-ip
 ifeq (, $(findstring amiga, $(OS)))