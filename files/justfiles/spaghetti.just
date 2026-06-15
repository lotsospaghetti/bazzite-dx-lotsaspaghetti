# Install some of my frequently-used Brew packages
[group('lotsaspaghetti')]
install-brew-packages:
    #!/usr/bin/bash
    echo "Installing Brew packages..."
    brew bundle --file=/usr/share/ublue-os/homebrew/spaghetti.Brewfile
