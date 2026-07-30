#!/data/data/com.termux/files/usr/bin/bash
set -e
pkg update -y && pkg install git -y
cd "$(dirname "$0")"
git init
git branch -M main
git add .
git commit -m "Deploy Explore India production portal" || true
git remote remove origin 2>/dev/null || true
git remote add origin "${1:?Usage: bash termux-push.sh https://github.com/USERNAME/REPOSITORY.git}"
git push -u origin main --force
