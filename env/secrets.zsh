# https://developer.1password.com/docs/cli/secret-references
# op://<vault-name>/<item-name>/[section-name/]<field-name>
export GITHUB_TOKEN=$(op item get "GITHUB_TOKEN" --vault "Postscript" --fields label=token --reveal)
