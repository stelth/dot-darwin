{
  lib,
  pkgs,
  ...
}: {
  xdg.configFile."efm-langserver/config.yaml".text = import ./efm.nix {inherit lib pkgs;};

  home.packages = with pkgs;
    [
      # mandatory
      nodejs
      efm-langserver

      # language servers
      nodePackages.bash-language-server # bash
      clang-tools_16 # c/cpp
      cmake-language-server # cmake
      nodePackages.dockerfile-language-server-nodejs # docker
      nodePackages.vscode-json-languageserver # json
      marksman
      nodePackages.pyright # python
      nil # nix
      nodePackages.vim-language-server # vim
      nodePackages.yaml-language-server # yaml

      # linters / formatters
      shellcheck # bash
      shfmt # bash
      cmake-format # c/cpp
      dprint # docker
      gitlint # git
      google-java-format # java
      nodePackages.fixjson # json
      nodePackages.jsonlint # json
      nodePackages.write-good # json
      alejandra # nix
      statix # nic
      (python3.withPackages (ps: with ps; [black flake8 isort pylint])) # python
      vim-vint # vim
      yamllint # yaml
    ]
    ++ lib.optionals (!pkgs.stdenvNoCC.isDarwin) [checkmake];

  programs.vim = {
    plugins = with pkgs.vimPlugins; [
      vim9-lsp
    ];
  };
}
