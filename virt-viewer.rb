class VirtViewer < Formula
  desc "App for virtualized guest interaction"
  homepage "https://virt-manager.org/"
  head "https://gitlab.com/virt-viewer/virt-viewer.git"

  depends_on "gettext" => :build
  depends_on "pkg-config" => :build

  depends_on "bash-completion@2" => :build
  depends_on "gobject-introspection" => :build
  depends_on "intltool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "shared-mime-info" => :build

  depends_on "glib"
  depends_on "gtk+3"
  depends_on "gtk-vnc"
  depends_on "libvirt-glib"
  depends_on "spice-gtk"
  depends_on "vte3"

  def install
    mkdir "build" do
      args = %w[
        -Dbash_completion=enabled
        -Dlibvirt=enabled
        -Dovirt=disabled
        -Dspice=enabled
        -Dvnc=enabled
        -Dvte=enabled
      ]
      system "meson", "setup", "..", *std_meson_args, *args
      system "ninja"
      system "ninja", "install"
    end
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
