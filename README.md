# dotfiles

<p align="center">
  <img src="screenshots/v2-nvim-and-tmux.png" width="600" />
</p>

<p align="center">
  <img src="https://github.com/crispgm/dotfiles/workflows/build/badge.svg" alt="GitHub CI" />
  <img src="https://img.shields.io/badge/platform-macOS-lightgray.svg" alt="platform" />
</p>

## Introduction

This is a dotfiles project which may be used to provision a new macOS with cosy dev setups.
And it is tested with GitHub Actions CI. The checkbox denotes whether it is done by `bootstrap`.
More screenshots [here](screenshots).

Inspired by [KrauseFx/new-mac](https://github.com/KrauseFx/new-mac).

For Arch Linux, please refer to [crispgm/arch-linux-dotfiles](https://github.com/crispgm/arch-linux-dotfiles).

## Bootstrap

```shell
$ xcode-select --install # or download here <https://developer.apple.com/download/more/>
$ git clone --recursive https://github.com/crispgm/dotfiles.git
# Login to AppStore with Apple ID, since there are MAS apps in Brewfile
$ cd dotfiles
$ ./bootstrap
```

`./bootstrap` 会执行 `brew bundle` 安装 `Brewfile` 中的软件；Neovim 的 `nvim-auto-ime` 依赖 `macism`，现已包含在该流程中。

## Project Layout

- `bootstrap`: entry point of dotfiles bootstrapping.
- `Brewfile`: all Homebrew formulae and casks managed by Homebrew Bundle.
- `rc`: dotfiles managed by [rcm](https://github.com/thoughtbot/rcm).
- `app`: customized boostrapping scripts for applications.

## Dev Setups

### Terminal & Shell

- [x] Install [Homebrew](https://brew.sh)
- [x] Setup Hostname `sudo scutil --set HostName david-macbook`
- [x] Install softwares and fonts from [Brewfile](https://github.com/crispgm/dotfiles/blob/master/Brewfile) with `brew bundle`. HINT: Login to AppStore at first. Some of the applications from Mac App Store may need purchase.
- [x] Install `fish`, [Fisher](https://github.com/jorgebucaran/fisher) and setup modular fish config (`config.fish` + `conf.d/` + `functions/`)
- [x] Load Homebrew environment in fish via `brew shellenv fish`
- [x] Setup [SDKMAN](https://sdkman.io/) with [sdkman-for-fish](https://github.com/reitzig/sdkman-for-fish) plugin
- [x] Keep bash on a shared loading chain: `.bash_profile` -> `.profile` + `.bashrc`
- [x] Setup tmux
- [x] Setup Neovim
- [x] Install `macism` for Neovim IME switching on macOS

### Git

- [x] Git global config
- [x] Git work config

### Ruby

- [x] Setup `.gemrc`
- [x] Setup bundler's mirror: `bundle config mirror.https://rubygems.org https://gems.ruby-china.com` if you locate in China mainland

### VSCode

- [x] Create `code` SymLink: `sudo ln -s /Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code ~/Applications/code`
- [x] Install `Setting Sync` extensions and then sync settings

### File Sync

- [x] Install your favorite file sync service (e.g. Dropbox, Google Drive, One Drive ... I prefer Dropbox because it works with Alfred)
- [ ] Setup syncing folder for apps (e.g. Alfred, Dash ...)

### Karabiner

- [x] Setup `karabiner.json`

## macOS Setups

### Trackpad

- [ ] Tap to click
- [ ] Seconary click: Click in bottom right corner

### Control Center

#### Battery

- [ ] Show Battery in Control Center
- [ ] Show percentage

#### Time

- [ ] Set time zone automatically using current location
- [ ] Use a 24-hour clock and show date

#### Siri

- [ ] Disable Siri system wide and remove Siri button from Touch Bar

### Finder

- [ ] New Finder show Desktop
- [ ] Remove labels and clean up Sidebar

### Dock

- [ ] Change to the size you like
- [ ] Cancel: Show recent application in Dock
- [ ] Downloads: View content as Grid
- [ ] Add blank seperator: `defaults write com.apple.dock persistent-apps -array-add '{tile-type="spacer-tile";}'`

## Optional Setups

### bash

- [x] Setup `.bash_profile`, `.profile`, `.bashrc`
- [x] Keep SDKMAN initialization guarded for Bash 4+ only on macOS
