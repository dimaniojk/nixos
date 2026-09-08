# Firefox как пользовательская программа, управляемая Home Manager.
{
  programs.firefox = {
    enable = true;

    # Сохраняем legacy-путь профиля, который Home Manager использует при stateVersion < 26.05.
    configPath = ".mozilla/firefox";
  };
}
