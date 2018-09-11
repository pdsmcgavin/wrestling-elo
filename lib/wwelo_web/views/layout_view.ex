defmodule WweloWeb.LayoutView do
  use WweloWeb, :view

  def js_script_tag do
    if Application.get_env(:wwelo, :environment) == :prod do
      ~s(<script src="/js/main.js"></script>)
    else
      ~s(<script src="http://localhost:8080/js/main.js"></script>)
    end
  end
end
