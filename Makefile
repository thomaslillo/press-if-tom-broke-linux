# Makefile for setting up Kubuntu

# Variables
APT = sudo apt-get
INSTALL = $(APT) install -y
SNAP = sudo snap install
FLATPAK = flatpak install --user -y flathub
PIP = pip3 install
OH_MY_ZSH = sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
KBD_SHORTCUT_CMD = kwriteconfig5 --file $$HOME/.config/kglobalshortcutsrc --group org.kde.spectacle.desktop --key "spectacle" "Ctrl+Shift+S,none,Spectacle"

# Default target
all: update install-dependencies install-programs configure-shortcut

# Update package list and install essential tools
update:
	$(APT) update
	$(INSTALL) curl git wget

# Install dependencies
install-dependencies:
	# Install Flatpak
	if ! command -v flatpak >/dev/null; then \
		$(INSTALL) flatpak; \
		sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo; \
	fi

	# Install Snap
	if ! command -v snap >/dev/null; then \
		$(INSTALL) snapd; \
		sudo systemctl enable --now snapd.socket; \
	fi

	# Install Spectacle
	$(INSTALL) spectacle

# Install programs
install-programs: install-thorium install-steam install-discord install-vscode install-pinta install-oh-my-zsh install-python

# Install Thorium Browser
install-thorium:
	sudo wget https://dl.thorium.rocks/debian/dists/stable/thorium.list -O /etc/apt/sources.list.d/thorium.list
	wget -qO - https://dl.thorium.rocks/debian/thorium.gpg | sudo apt-key add -
	$(APT) update
	$(INSTALL) thorium-browser

# Install Steam
install-steam:
	$(INSTALL) steam

# Install Discord
install-discord:
	$(INSTALL) discord

# Install VS Code
install-vscode:
	$(SNAP) code --classic

# Install Pinta
install-pinta:
	$(FLATPAK) pinta

# Install oh-my-zsh and set as default shell
install-oh-my-zsh:
	$(INSTALL) zsh
	$(OH_MY_ZSH) "" --unattended
	chsh -s $$(command -v zsh)
	@exec zsh

# Install Python
install-python:
	$(INSTALL) python3 python3-pip

# Configure keyboard shortcut
configure-shortcut:
	$(KBD_SHORTCUT_CMD)
	qdbus org.kde.kglobalaccel /component/spectacle reconfigure

# Clean up
clean:
	$(APT) autoremove -y
	$(APT) autoclean -y

.PHONY: all update install-dependencies install-programs install-thorium install-steam install-discord install-vscode install-pinta install-oh-my-zsh install-python configure-shortcut clean
