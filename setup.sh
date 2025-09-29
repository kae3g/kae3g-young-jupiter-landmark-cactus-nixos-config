#!/usr/bin/env bash

# Setup script for kae3g Young Jupiter Landmark Cactus NixOS Configuration
# This script helps users customize the configuration template

set -e

echo "🌵 kae3g Young Jupiter Landmark Cactus NixOS Configuration Setup"
echo "============================================================="
echo ""

# Check if secrets.nix already exists
if [ -f "secrets.nix" ]; then
    echo "⚠️  secrets.nix already exists!"
    read -p "Do you want to overwrite it? (y/N): " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Setup cancelled."
        exit 0
    fi
fi

# Copy template
echo "📋 Creating secrets.nix from template..."
cp secrets.nix.template secrets.nix

echo ""
echo "✅ Setup complete!"
echo ""
echo "📝 Next steps:"
echo "1. Edit secrets.nix with your personal information"
echo "2. Update your username, email, GPG key, editor preference, etc."
echo "3. Copy the configuration files to /etc/nixos/"
echo "4. Run: sudo nixos-rebuild switch --flake /etc/nixos#nixos"
echo ""
echo "🔧 For Framework 16 users: Keep the hardware optimizations enabled"
echo "🖥️  For other systems: Disable AMD/Framework optimizations in secrets.nix"
echo ""
echo "📖 See README.md for detailed instructions" 