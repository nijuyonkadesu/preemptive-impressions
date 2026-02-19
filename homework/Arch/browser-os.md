# PKGBUILD

```sh
makepkg -g
makepkg -si
```

```conf
# Maintainer: shadowfax92 at github

_pkgname=BrowserOS

pkgname="${_pkgname}"-appimage
pkgver=0.40.1
aarch="x64"
pkgrel=1
pkgdesc="Agentic Browser"
arch=('x86_64')
url="https://github.com/browseros-ai/BrowserOS"
license=('AGPL-3.0')
depends=('zlib' 'fuse2')
options=(!strip)
_appimage="${_pkgname}_v${pkgver}_${aarch}.AppImage"
source_x86_64=("${_appimage}::https://github.com/browseros-ai/BrowserOS/releases/download/v${pkgver}/${_appimage}"
               "https://raw.githubusercontent.com/browseros-ai/BrowserOS/v${pkgver}/LICENSE"
              )
noextract=("${_appimage}")
sha256sums_x86_64=('bad20ce48210956cc27c36ec47495993ae659b65db9a759889f6e8a3aa3bd744'
                   '8486a10c4393cee1c25392769ddd3b2d6c242d6ec7928e1414efff7dfb2f07ef')

prepare() {
    chmod +x "${_appimage}"
    ./"${_appimage}" --appimage-extract
}

build() {
    # Adjust .desktop so it will work outside of AppImage container
    sed -i -E "s|Exec=AppRun|Exec=env DESKTOPINTEGRATION=false /usr/bin/${_pkgname}|"\
        "squashfs-root/${_pkgname,,}.desktop"
    # Fix permissions; .AppImage permissions are 700 for all directories
    chmod -R a-x+rX squashfs-root/usr
}

package() {
    # AppImage
    install -Dm755 "${srcdir}/${_appimage}" "${pkgdir}/opt/${pkgname}/${pkgname}.AppImage"
    install -Dm644 "${srcdir}/LICENSE" "${pkgdir}/opt/${pkgname}/LICENSE"

    # Desktop file
    install -Dm644 "${srcdir}/squashfs-root/${_pkgname,,}.desktop"\
            "${pkgdir}/usr/share/applications/${_pkgname,,}.desktop"

    # Icon images
    install -dm755 "${pkgdir}/usr/share/"
    cp -a "${srcdir}/squashfs-root/usr/share/icons" "${pkgdir}/usr/share/"

    # Symlink executable
    install -dm755 "${pkgdir}/usr/bin"
    ln -s "/opt/${pkgname}/${pkgname}.AppImage" "${pkgdir}/usr/bin/${_pkgname}"

    # Symlink license
    install -dm755 "${pkgdir}/usr/share/licenses/${pkgname}/"
    ln -s "/opt/$pkgname/LICENSE" "$pkgdir/usr/share/licenses/$pkgname"
}
```
