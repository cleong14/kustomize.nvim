# kustomize.nvim

I work a lot with [Kustomize](https://kustomize.io/) and I love Neovim. So why not write a plugin for some tasks for that I usually switch to a shell.
Jump to the [use cases](#use-cases) to check out what this plugin can do!

⚠ This is my first Neovim plugin so any Feedback is appreciated!

## Requirements

- kustomize must be installed and in your $PATH
- [plenary.nvim](https://github.com/nvim-lua/plenary.nvim)

## Quickstart

With Packer:

```lua
  use({
    "allaman/kustomize.nvim",
    requires = "nvim-lua/plenary.nvim",
    ft = "yaml",
    config = "require('kustomize').setup()",
  })
```

## Default mappings

| Mode | Mapping      | Action          | Lua                                | Command               |
| ---- | ------------ | --------------- | ---------------------------------- | --------------------- |
| n    | \<leader\>kb | Kustomize build | `lua require("kustomize").build()` | `:KustomizeBuild`     |
| n    | \<leader\>kk | List kinds      | `lua require("kustomize").kinds()` | `:KustomizeKindsList` |
| v    | \<leader\>ko | Open file       | `lua require("kustomize").open()`  | `:KustomizeOpen`      |

You can define your own keybindings. Just don't call `setup()` and create mappings on your own.

## Use cases

### Build manifests

<details>
<summary>Showcase</summary

![kustomize.nvim-build.gif](https://s4.gifyu.com/images/kustomize.nvim-build.gif)

</details>

If your buffer contains a `kustomization.yaml` this command will run `kustomize build . ` in the buffer's directory. The generated YAML will printed to a new buffer. The new buffer can be closed by just typing `q`.
This allows me to quickly inspect the YAML that Kustomize generates (and ultimately is applied to the cluster). In addition, I get fast feedback on any errors in my YAML sources.

### List "kinds"

<details>
<summary>Showcase</summary

![kustomize.nvim-kinds.gif](https://s1.gifyu.com/images/kustomize.nvim-kinds.gif)

</details>

Sometimes, I just want to roughly check the YAMLs generated by Kustomize. A good hint is to check the `kind:` key of the generated YAML manifests. This command will parse all resource types in the current buffer and prints them to a new buffer. The new buffer can be closed by just typing `q`. You could use it on any YAML file with multiple resources, for instance generated by [Build manifests](#build-manifests)

### Open file

<details>
<summary>Showcase</summary

![kustomize.nvim-open.gif](https://s4.gifyu.com/images/kustomize.nvim-open.gif)

</details>

You list your YAMLs that should be included by Kustomize for the build of the final manifests like so:

```yaml
---
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
  - service1/
  - grafana-dashboard.yaml
  - ../../base/namespace.yaml
```

In order to quickly check/edit those included YAMLs this command will open a visually selected file in the current window in a new buffer. `..` is supported. Folders are opened via `netrw`.

### TODO

- [ ] use treesitter for parsing
- [ ] nicer and configurable output (floating, split, ...)
- [ ] error handling for unexpected window layouts
