#!/usr/bin/env bash
set -u

# ==============================================================================
# Script de Setup: Estudos, Desenvolvimento & Produtividade (CachyOS)
# ==============================================================================

NAVEGADORES=(
    firefox
    chromium
)

IDES_EDITORES=(
    visual-studio-code-bin
    intellij-idea-oss
    pycharm-community-edition
    sublime-text-4
    neovim
    vim
    micro
    nano
)

LINGUAGENS_SDKS=(
    base-devel
    python
    python-requests
    python-packaging
    python-defusedxml
    nodejs
    dotnet-sdk
    dotnet-runtime
    aspnet-runtime
    aspnet-targeting-pack
    jre25-openjdk-headless
    perl
)

DEV_REDE_TERMINAL=(
    git
    meld
    sqlitebrowser
    alacritty
    tmux
    stow
    zoxide
    tree
    vivid
    plocate
    openssh
    tailscale
    anydesk-bin
    networkmanager-openvpn
    ufw
    firewall-config
    pacman-contrib
    reflector
    rebuild-detector
    shelly
)

ESTUDOS_MIDIA=(
    obsidian
    okular
    zathura
    zathura-pdf-mupdf
    libreoffice-fresh-pt-br
    flameshot
    spectacle
    satty
    vlc-plugins-all
)

SISTEMA_UTILITARIOS=(
    btrfs-assistant
    snapper
    limine-snapper-sync
    kup
    fsarchiver
    btop
    htop
    glances
    duf
    fastfetch
    7zip
    unzip
    unrar
    zip
    file-roller
    flatpak
)

FLATPAKS=(
    app.zen_browser.zen
    com.brave.Browser
    me.proton.Mail
    com.github.tchx84.Flatseal
    org.fedoraproject.MediaWriter
    # com.discordapp.Discord  # Descomente se quiser instalar o Discord
)

# ------------------------------------------------------------------------------
# Execução
# ------------------------------------------------------------------------------

if [[ $EUID -eq 0 ]]; then
    echo "Execute este script como usuário normal (não use sudo diretamente)."
    exit 1
fi

echo "==> Atualizando sistema e sincronizando repositórios..."
sudo pacman -Syu --noconfirm

# Detecta AUR helper (paru vem por padrão no CachyOS)
if command -v paru &>/dev/null; then
    AUR_HELPER="paru"
elif command -v yay &>/dev/null; then
    AUR_HELPER="yay"
else
    echo "==> Instalando paru..."
    sudo pacman -S --needed --noconfirm paru
    AUR_HELPER="paru"
fi

FALHAS=()

instalar_grupo() {
    local titulo="$1"
    shift
    local pacotes=("$@")

    echo ""
    echo "==> Instalando: $titulo"
    if ! $AUR_HELPER -S --needed --noconfirm "${pacotes[@]}"; then
        echo "   [!] Falha no lote. Tentando pacote por pacote..."
        for pkg in "${pacotes[@]}"; do
            if ! $AUR_HELPER -S --needed --noconfirm "$pkg"; then
                FALHAS+=("$pkg")
            fi
        done
    fi
}

instalar_grupo "Navegadores" "${NAVEGADORES[@]}"
instalar_grupo "IDEs e Editores" "${IDES_EDITORES[@]}"
instalar_grupo "Linguagens e SDKs" "${LINGUAGENS_SDKS[@]}"
instalar_grupo "Dev, Rede e Terminal" "${DEV_REDE_TERMINAL[@]}"
instalar_grupo "Estudos, Leitura e Mídia" "${ESTUDOS_MIDIA[@]}"
instalar_grupo "Sistema, Backup e Utilitários" "${SISTEMA_UTILITARIOS[@]}"

echo ""
echo "==> Configurando Flathub e instalando Flatpaks..."
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
for app in "${FLATPAKS[@]}"; do
    if ! flatpak install -y flathub "$app"; then
        FALHAS+=("flatpak:$app")
    fi
done

echo ""
echo "==> Ativando serviços essenciais (Tailscale e UFW)..."
sudo systemctl enable --now tailscaled.service 2>/dev/null || true
sudo systemctl enable --now ufw.service 2>/dev/null || true

echo ""
echo "=================================================================="
echo "Instalação concluída!"
if [ ${#FALHAS[@]} -gt 0 ]; then
    echo "Os seguintes pacotes não foram encontrados ou falharam:"
    printf ' - %s\n' "${FALHAS[@]}"
fi
echo "=================================================================="
