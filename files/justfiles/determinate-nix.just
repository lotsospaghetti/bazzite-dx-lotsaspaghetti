alias configure-nix := configure-determinate-nix

NIX_INSTALLER := "/nix/nix-installer"
NIX_RECEIPT := "/nix/receipt.json"

# Configure the Nix package manager from Determinate Systems (https://github.com/DeterminateSystems/nix-installer)
[group('nix')]
configure-determinate-nix ACTION="":
    #!/usr/bin/bash
    set -euo pipefail
    source /usr/lib/ujust/ujust.sh 2>/dev/null || true

    ACTION="{{ ACTION }}"; ACTION="${ACTION,,}"
    NIX_INSTALLER="{{ NIX_INSTALLER }}"
    NIX_RECEIPT="{{ NIX_RECEIPT }}"

    install_status="Not installed"
    if [[ -f $NIX_RECEIPT ]] && [[ -x $NIX_INSTALLER ]]; then
        if /nix/nix-installer self-test &>/dev/null; then
            install_status="Installed"
        else
            install_status="Installed with issues"
        fi
    fi

    if [[ $ACTION == "help" ]]; then
        echo "Usage: ujust configure-determinate-nix [install|repair|uninstall]"
        echo "If no action is provided you'll be prompted with a picker."
        exit 0
    fi

    CHOICE=""
    if [[ -z $ACTION ]]; then
        echo -e "Nix status: ${bold}${install_status}${normal}\n"
        echo "What would you like to do?"
        if [[ $install_status =~ ^[Nn]ot.* ]]; then
            CHOICE=$(ugum choose \
                    "Begin install" \
                    "Exit without changes")
        else
            CHOICE=$(ugum choose \
                    "Repair install" \
                    "Remove nix" \
                    "Exit without changes")
        fi
    else
        case "$ACTION" in
            install) CHOICE="Begin install" ;;
            repair) CHOICE="Repair install" ;;
            remove) CHOICE="Remove nix" ;;
            *) echo "Unrecognized action: $ACTION" ; exit 1 ;;
        esac
    fi

    case "$CHOICE" in
        "Begin install")
            echo "Installing Determinate Nix..."
            curl -fsSL https://install.determinate.systems/nix | sh -s -- install
            ;;
        "Repair install")
            echo "Attempting to repair Nix..."
            "$NIX_INSTALLER" repair
            ;;
        "Remove install")
            echo "Removing Determinate Nix..."
            "$NIX_INSTALLER" uninstall --no-confirm "$NIX_RECEIPT"
            ;;
        "Exit without changes"|"")
            echo "No changes made."
            exit 0
            ;;
        *)
            echo "Unkown selection: $CHOICE" >&2
            exit 1
            ;;
    esac

# Wrapper for the nix-installer binary, since it doesn't get added to PATH
[group('nix')]
nix-installer:
    #!/usr/bin/bash
    NIX_INSTALLER="{{ NIX_INSTALLER }}"
    if [[ -x $NIX_INSTALLER ]]; then
        sh -c "$NIX_INSTALLER" "$@"
    else
        echo "Nix is not installed, please run 'ujust configure-determinate-nix install' first." >&2
        exit 1
    fi
