# config_desktop

Mis configuraciones de escritorio en Linux (Ubuntu / GNOME).

## Contenido

| Carpeta       | Qué guarda                                              | Destino en el sistema            |
| ------------- | ------------------------------------------------------- | -------------------------------- |
| `starship/`   | Prompt de [Starship](https://starship.rs)                | `~/.config/starship.toml`        |
| `vim/`        | `.vimrc`, ajustes de coc, tema monokai y diccionario     | `~/.vimrc`, `~/.vim/`            |
| `wallpapers/` | Fondos de pantalla                                       | `~/.local/share/backgrounds/`    |

## Instalación

```bash
git clone <url-del-repo> ~/config_desktop
cd ~/config_desktop
./install.sh
```

El script crea **enlaces simbólicos** desde el home hacia este repo, así que
cualquier cambio que hagas luego en `~/.vimrc` queda reflejado en el repo y solo
hay que hacer `git commit`. Si ya existía un archivo en el destino, se respalda
en `~/.config-desktop-backup/<fecha>/` antes de reemplazarlo.

### Después de instalar

- **Starship** — asegúrate de tener la línea en tu `~/.bashrc`:

  ```bash
  eval "$(starship init bash)"
  ```

  Si no tienes starship instalado:

  ```bash
  curl -sS https://starship.rs/install.sh | sh
  ```

- **Vim** — abre vim y ejecuta `:PlugInstall`. El script ya descarga vim-plug si
  falta. Los plugins (`~/.vim/plugged/`) **no** se versionan: son 128 MB y
  vim-plug los reinstala desde `.vimrc`.

  `coc.nvim` necesita Node.js. Las extensiones de coc se instalan aparte, por
  ejemplo: `:CocInstall coc-tsserver coc-json`.

- **Wallpaper** — para fijar uno:

  ```bash
  gsettings set org.gnome.desktop.background picture-uri \
      "file://$HOME/.local/share/backgrounds/wallpaper-01.jpg"
  gsettings set org.gnome.desktop.background picture-uri-dark \
      "file://$HOME/.local/share/backgrounds/wallpaper-01.jpg"
  ```

## Añadir una configuración nueva

1. Mueve el archivo al repo: `mv ~/.config/loquesea.conf ~/config_desktop/loquesea/`
2. Agrega la línea correspondiente en `install.sh`.
3. Ejecuta `./install.sh` para crear el enlace.
