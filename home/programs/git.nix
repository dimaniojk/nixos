# Пользовательская идентичность Git и дефолтная ветка для новых репозиториев.
{
  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "Dimaniojk";
        email = "deividasjk001@gmail.com";
      };

      init.defaultBranch = "main";
    };
  };
}
