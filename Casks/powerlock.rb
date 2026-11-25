cask "powerlock" do
  version "1.3.1"
  sha256 "40b3a7712149f0f4bb4ed89684e8e13225e40ab4e21b87c55408fcf60e662504"

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

  # 之前从 dmg 手动装过 PowerLock 时，/Applications 里已经有一份 Homebrew 不认识的 App，
  # 默认会报 "It seems there is already an App" 并停下。这里先退出它，再删掉旧 App，
  # 由 Homebrew 装新版。只在它的 Info.plist 里有 com.powerlock.app 时才删，别的同名 App 不碰。
  # 后台助手和用户设置都不动，所以从 1.1 以后的版本升级不用重新输入管理员密码。
  preflight_steps do
    if_path_exists "PowerLock.app/Contents/Info.plist", base: :appdir do
      terminate_process "PowerLock"
      remove "PowerLock.app/Contents/Info.plist",
             base:             :appdir,
             content_contains: "<string>com.powerlock.app</string>"
      unless_path_exists "PowerLock.app/Contents/Info.plist", base: :appdir do
        remove "PowerLock.app", base: :appdir, recursive: true
      end
    end
  end

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
    PowerLock is not notarized yet. If macOS says it can't verify PowerLock,
    open System Settings > Privacy & Security, click "Open Anyway", then open
    PowerLock again.

    PowerLock installs a background helper the first time you enable it.
    To remove the helper, use More > "Uninstall PowerLock…" in the menu bar
    before uninstalling, or run:
      brew uninstall --zap --cask powerlock
  EOS
end
