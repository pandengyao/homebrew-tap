# Homebrew Cask 模板，发布在 pandengyao/homebrew-tap。
# 发版后把 version 和 sha256 更新为新 dmg 的值（见 docs/RELEASE_CHECKLIST.md）。
cask "powerlock" do
  version "1.3.0"
  sha256 "890a87dd7b991cb2d44a726eab1b70ae8c382f22b20f3b592aaee183c42ca948"

  url "https://github.com/pandengyao/PowerLock/releases/download/v#{version}/PowerLock-#{version}.dmg"
  name "PowerLock"
  desc "Keep the computer unlocked and awake with the lid closed while on AC power"
  homepage "https://github.com/pandengyao/PowerLock"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :ventura

  app "PowerLock.app"

  # uninstall 段在 brew upgrade 时也会执行，所以这里只退出 App（升级后 Homebrew 会重新打开它），
  # 不删除后台助手；否则每次升级都要重新输入管理员密码安装助手。
  uninstall quit: "com.powerlock.app"

  # 删除后台助手放在 zap：brew uninstall --zap --cask powerlock。
  # launchctl 会停止助手，助手退出前自己恢复 pmset 设置。
  zap launchctl: "com.powerlock.helper",
      delete:    [
        "/Library/Application Support/PowerLock",
        "/Library/PrivilegedHelperTools/com.powerlock.helper",
      ],
      trash:     [
        "~/Library/Application Support/PowerLock",
        "~/Library/LaunchAgents/com.powerlock.login.plist",
      ]

  caveats <<~EOS
    PowerLock installs a background helper the first time you enable it.
    To remove the helper, use More > "Uninstall PowerLock…" in the menu bar
    before uninstalling, or run:
      brew uninstall --zap --cask powerlock
  EOS
end
