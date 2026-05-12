#!/bin/bash

UPDATE_XBPS=false
UPDATE_FLATPAK=false
UPDATE_GLANCE=false
UPDATE_SEARXNG=false
UPDATE_PIHOLE=false
UPDATE_NEOVIM=false
UPDATE_TLDR=false
UPDATE_QUTEBROWSER_ADDBLOCK=false
AUTO_CONFIRM=false

while getopts "xfgpsntqy" opt; do
  case $opt in
  x) UPDATE_XBPS=true ;;
  f) UPDATE_FLATPAK=true ;;
  g) UPDATE_GLANCE=true ;;
  p) UPDATE_PIHOLE=true ;;
  s) UPDATE_SEARXNG=true ;;
  n) UPDATE_NEOVIM=true ;;
  t) UPDATE_TLDR=true ;;
  q) UPDATE_QUTEBROWSER_ADDBLOCK=true ;;
  y) AUTO_CONFIRM=true ;;
  \?) exit 1 ;;
  esac
done

if [ $OPTIND -eq 1 ]; then
  UPDATE_XBPS=true
  UPDATE_FLATPAK=true
  UPDATE_GLANCE=true
  UPDATE_SEARXNG=true
  UPDATE_PIHOLE=true
  UPDATE_NEOVIM=true
  UPDATE_TLDR=true
  UPDATE_QUTEBROWSER_ADDBLOCK=true
fi

if [ "$UPDATE_XBPS" = true ]; then
  echo -e "\n=====> XBPS <====="
  [ "$AUTO_CONFIRM" = true ] && sudo xbps-install -Syu || sudo xbps-install -Su
fi

if [ "$UPDATE_FLATPAK" = true ]; then
  if command -v flatpak >/dev/null 2>&1; then
    echo -e "\n=====> Flatpak <====="
    [ "$AUTO_CONFIRM" = true ] && flatpak update -y || flatpak update
  fi
fi

if [ "$UPDATE_TLDR" = true ]; then
  echo -e "\n=====> TL;DR <====="
  tldr -u
fi

if [ "$UPDATE_NEOVIM" = true ]; then
  if command -v nvim >/dev/null 2>&1; then
    echo -e "\n=====> Neovim <====="
    nvim --headless "+Lazy! update" +qa
    nvim --headless -c "TSUpdate" -c "qa"
    nvim --headless -c "lua \
      local r = require('mason-registry') \
      r.refresh(function() \
      local installed = r.get_installed_packages() \
      local count = #installed \
      if count == 0 then vim.cmd('qa') return end \
        for _, p in ipairs(installed) do \
          p:once('install:success', function() count = count - 1 end) \
          p:once('install:failed', function() count = count - 1 end) \
          p:install() \
        end \
        local check = vim.loop.new_timer() \
        check:start(0, 500, vim.schedule_wrap(function() \
        if count <= 0 then vim.cmd('qa') end \
        end)) \
      end)"
  fi
fi

if command -v qutebrowser >/dev/null 2>&1; then
  if [ "$UPDATE_QUTEBROWSER_ADDBLOCK" = true ]; then
    echo -e "\n=====> Qutebrowser Adblock <====="
    timeout 5s qutebrowser :adblock-update --qt-arg headless >/dev/null 2>&1 &
  fi
fi

if [ "$UPDATE_PIHOLE" = true ]; then
  pihole_running=$(sudo podman inspect -f '{{.State.Running}}' pihole 2>/dev/null)

  if [ "$pihole_running" == "true" ]; then
    echo -e "\n=====> PiHole <====="

    builtin cd "$HOME/.container/pihole/"
    sudo podman-compose pull
    sudo podman-compose up -d

    for i in {1..10}; do
      sudo podman exec pihole pihole status | grep -q "DNS service is listening" && break
      sleep 1
    done

    sudo podman exec pihole pihole updateGravity
    sudo podman image prune -f
    builtin cd - >/dev/null
  fi
fi

if [ "$UPDATE_SEARXNG" = true ]; then
  searxng_running=$(sudo podman inspect -f '{{.State.Running}}' searxng 2>/dev/null)

  if [ "$searxng_running" == "true" ]; then
    echo -e "\n=====> SearXNG <====="

    builtin cd "/home/matt/.container/searxng/"

    sudo podman-compose pull
    sudo podman-compose up -d

    for i in {1..15}; do
      if sudo podman exec searxng ss -tulpn 2>/dev/null | grep -q ":8080"; then
        break
      fi
      sleep 1
    done

    sudo podman image prune -f
    builtin cd - >/dev/null
  fi
fi

if [ "$UPDATE_GLANCE" = true ]; then
  glance_running=$(sudo podman inspect -f '{{.State.Running}}' glance 2>/dev/null)

  if [ "$glance_running" == "true" ]; then
    echo -e "\n=====> Glance <====="

    builtin cd "/home/matt/.container/glance/"
    sudo podman-compose pull
    sudo podman-compose up -d

    for i in {1..10}; do
      if sudo podman exec glance ss -tulpn 2>/dev/null | grep -q ":8080"; then
        break
      fi
      sleep 1
    done

    sudo podman image prune -f
    builtin cd - >/dev/null
  fi
fi
