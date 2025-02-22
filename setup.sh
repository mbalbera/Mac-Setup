#!/bin/bash

# Exit on error
set -e

# Install Homebrew if not installed
if ! command -v brew &>/dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    echo "Homebrew is already installed. Updating..."
    brew update
fi

# Install essential packages
echo "Installing essential packages..."
brew install node nvm yarn git python postgresql

# Ensure Python alias is set
if ! command -v python &>/dev/null; then
    echo "Setting Python alias..."
    echo "alias python=python3" >> ~/.zshrc
    source ~/.zshrc
fi

# Set up NVM
echo "Setting up NVM..."
mkdir -p ~/.nvm
export NVM_DIR="$HOME/.nvm"
source $(brew --prefix nvm)/nvm.sh

echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.zshrc
echo '[ -s "$(brew --prefix nvm)/nvm.sh" ] && \. "$(brew --prefix nvm)/nvm.sh"' >> ~/.zshrc

# Install latest Node.js with NVM
nvm install node
nvm use node

# Install Ruby on Rails
echo "Installing Ruby on Rails..."
brew install ruby
gem install rails

# Install Create React App alternative (Vite)
echo "Installing Vite (modern alternative to Create React App)..."
npm install -g vite

# Start PostgreSQL service
echo "Setting up PostgreSQL..."
brew services start postgresql

# Set up SSH key if not already present
if [ ! -f ~/.ssh/id_rsa ]; then
    echo "Creating SSH key..."
    ssh-keygen -t rsa -b 4096 -C "mhbalbera@gmail.com" -f ~/.ssh/id_rsa -N ""
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_rsa
    echo "SSH key created. Add this key to your GitHub or other services:"
    cat ~/.ssh/id_rsa.pub
else
    echo "SSH key already exists."
fi

echo "Setup complete!"
