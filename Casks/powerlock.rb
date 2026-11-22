# Homebrew Cask 模板
# 已发布到 pandengyao/homebrew-tap。
#
# 注意：助手是系统级 launchd 服务，建议先让用户在 App 菜单里
# 执行「卸载后台助手…」再删除 App，避免残留。
cask "powerlock" do
  version "1.0.1"
  sha256 "c8d5ed7577b4dbdd1ceb16157e574076e5a7399f700385512ae26001f5d68eac"

  url "https://github.com/pandengyao/PowerLock/releases/download/v#{version}/PowerLock-#{version}.dmg"
  name "PowerLock"
  desc "Keep your Mac awake and unlocked while on AC power"
  homepage "https://github.com/pandengyao/PowerLock"

  app "PowerLock.app"

  zap trash: [
    "~/Library/Application Support/PowerLock",
    "~/Library/LaunchAgents/com.powerlock.login.plist",
    "~/Library/Logs/PowerLock.log"
  ]
end
