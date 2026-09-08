# Локальный LiteLLM proxy для маршрутизации запросов к локальной OpenAI-compatible модели.
{
  services.litellm = {
    enable = true;
    host = "127.0.0.1";
    port = 4000;

    settings = {
      model_list = [
        {
          model_name = "verity-local";

          litellm_params = {
            model = "openai/local";
            api_base = "http://127.0.0.1:8080/v1";
            api_key = "none";

            extra_body = {
              chat_template_kwargs = {
                # Отключает thinking в chat template локальной модели.
                enable_thinking = false;
              };
            };
          };
        }
      ];

      litellm_settings = {
        drop_params = true;
      };
    };
  };
}
