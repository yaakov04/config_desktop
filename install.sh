#!/usr/bin/env bash
#
# Instala las configuraciones de este repo creando enlaces simbólicos
# hacia el home. Así, editar el archivo en el home edita el del repo.
#
# Uso:  ./install.sh
#
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP="$HOME/.config-desktop-backup/$(date +%Y%m%d-%H%M%S)"

info()  { printf '\033[1;32m==>\033[0m %s\n' "$1"; }
warn()  { printf '\033[1;33m==>\033[0m %s\n' "$1"; }

# link <origen-en-repo> <destino-en-home>
link() {
    local src="$1" dest="$2"

    if [ -L "$dest" ] && [ "$(readlink -f "$dest")" = "$src" ]; then
        info "ya enlazado: $dest"
        return
    fi

    if [ -e "$dest" ] || [ -L "$dest" ]; then
        mkdir -p "$BACKUP/$(dirname "${dest#"$HOME"/}")"
        mv "$dest" "$BACKUP/${dest#"$HOME"/}"
        warn "respaldado: $dest -> $BACKUP/${dest#"$HOME"/}"
    fi

    mkdir -p "$(dirname "$dest")"
    ln -s "$src" "$dest"
    info "enlazado: $dest"
}

# --- starship ---------------------------------------------------------------
link "$REPO/starship/starship.toml" "$HOME/.config/starship.toml"

# --- vim --------------------------------------------------------------------
link "$REPO/vim/vimrc"                       "$HOME/.vimrc"
link "$REPO/vim/coc-settings.json"           "$HOME/.vim/coc-settings.json"
link "$REPO/vim/colors/monokai.vim"          "$HOME/.vim/colors/monokai.vim"
link "$REPO/vim/dictionary/dictionary.txt"   "$HOME/.vim/dictionary/dictionary.txt"

# vim-plug: no se versiona, se descarga si falta
if [ ! -f "$HOME/.vim/autoload/plug.vim" ]; then
    info "instalando vim-plug..."
    curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    info "abre vim y ejecuta :PlugInstall para instalar los plugins"
else
    info "vim-plug ya instalado"
fi

# --- bash -------------------------------------------------------------------
# No se enlaza el .bashrc entero (es el stock de la distro): se le añade un
# source al final, una sola vez.
BASHRC="$HOME/.bashrc"

if [ -f "$BASHRC" ] && grep -qF 'bash/bashrc.custom' "$BASHRC"; then
    info "~/.bashrc ya carga bashrc.custom"
else
    mkdir -p "$BACKUP"
    cp "$BASHRC" "$BACKUP/.bashrc" 2>/dev/null || true
    {
        echo
        echo "# config_desktop"
        echo "[ -f \"$REPO/bash/bashrc.custom\" ] && . \"$REPO/bash/bashrc.custom\""
    } >> "$BASHRC"
    info "añadido source de bashrc.custom a ~/.bashrc"
    warn "revisa que no te queden duplicados de nvm/starship/alias en ~/.bashrc"
fi

# --- wallpapers -------------------------------------------------------------
mkdir -p "$HOME/.local/share/backgrounds"
for wp in "$REPO"/wallpapers/*; do
    [ -e "$wp" ] || continue
    link "$wp" "$HOME/.local/share/backgrounds/$(basename "$wp")"
done

echo
info "listo."
[ -d "$BACKUP" ] && warn "archivos previos respaldados en: $BACKUP"
echo "    bash:     recarga con  ->  source ~/.bashrc"
echo "    starship: si no lo tienes  ->  curl -sS https://starship.rs/install.sh | sh"
echo "    vim:      abre vim y ejecuta :PlugInstall"
echo "    fondo:    gsettings set org.gnome.desktop.background picture-uri \\"
echo "                  \"file://\$HOME/.local/share/backgrounds/wallpaper-01.jpg\""
