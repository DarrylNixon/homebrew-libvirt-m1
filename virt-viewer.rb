class VirtViewer < Formula
  desc "App for virtualized guest interaction"
  homepage "https://virt-manager.org/"
  url "https://releases.pagure.org/virt-viewer/virt-viewer-11.0.tar.xz"
  sha256 "a43fa2325c4c1c77a5c8c98065ac30ef0511a21ac98e590f22340869bad9abd0"

  depends_on "gettext" => :build
  depends_on "pkg-config" => :build

  depends_on "glib"
  depends_on "gtk+3"
  depends_on "gtk-vnc"
  depends_on "libvirt-glib"
  depends_on "spice-gtk"

  def install
    args = %W[
      --disable-silent-rules
      --disable-update-mimedb
      --with-gtk-vnc
      --with-spice-gtk
      --prefix=#{prefix}
    ]
    system "./configure", *args
    system "make", "install"
  end

  def post_install
    # manual update of mime database
    system "#{Formula["shared-mime-info"].opt_bin}/update-mime-database", "#{HOMEBREW_PREFIX}/share/mime"
    # manual icon cache update step
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    system "#{bin}/virt-viewer", "--version"
  end
end
