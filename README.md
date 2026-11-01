# config_desktop

Mis configuraciones de escritorio en Linux (Ubuntu / GNOME).

## Contenido

| Carpeta       | Qué guarda                                              | Destino en el sistema            |
| ------------- | ------------------------------------------------------- | -------------------------------- |
| `starship/`   | Prompt de [Starship](https://starship.rs)                | `~/.config/starship.toml`        |
| `vim/`        | `.vimrc`, ajustes de coc, tema monokai y diccionario     | `~/.vimrc`, `~/.vim/`            |
| `bash/`       | Añadidos propios al `.bashrc` (nvm, PATH, alias)         | `source` desde `~/.bashrc`       |
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

El `.bashrc` es la excepción: no se enlaza, porque las primeras ~117 líneas son
el stock de la distro. En su lugar `install.sh` le añade al final un `source` de
`bash/bashrc.custom`, que es donde viven los añadidos propios (nvm, PATH, el
alias `npm` → `pnpm` y el init de starship).

### Después de instalar

- **Bash** — recarga la shell:

  ```bash
  source ~/.bashrc
  ```

  Si instalas sobre una máquina que ya tenía estas líneas sueltas en el
  `.bashrc`, bórralas a mano para no cargarlas dos veces.

- **Starship** — si no lo tienes instalado:

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
