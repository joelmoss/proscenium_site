# Proscenium Site, Docs and Registry

https://proscenium.rocks

## Registry

The Proscenium Registry provides a way for you to consume JS and CSS from any published Ruby Gem via an NPM compatible package manager (eg. npm, yarn, pnpm), in your Proscenium backed application.

Just tell your package manager about the Proscenium Registry, and you’ll be able to install and use the assets from any Ruby Gem without needing to publish them to NPM.

As an example, assume you have a Ruby Gem called `my_gem` that includes some JavaScript and CSS files. You could add the Proscenium Registry to your package manager configuration and then install the assets like this:

```bash
npm install @rubygems/my_gem
```

This would allow you to use the assets from `my_gem` in your project without any additional steps. Just import them like you would any NPM package:

```javascript
import '@rubygems/my_gem/styles.css';
import '@rubygems/my_gem/scripts.js';
```

### Usage

The Proscenium registry relies on a lesser known feature of NPM called "scoped packages". This allows you to install packages under a specific namespace, in this case, `@rubygems`.

To use the Proscenium Registry, you need to configure your package manager to recognize it. Here’s how you can do that for different package managers:

#### npm/pnpm

1. Create a `.npmrc` file in your project root (if you don’t have one already).
2. Add the following line to the `.npmrc` file:

```
@rubygems:registry=https://registry.proscenium.rocks
```

#### yarn

1. Create a `.yarnrc` file in your project root (if you don’t have one already).
2. Add the following line to the `.yarnrc` file:

```
@rubygems:registry=https://registry.proscenium.rocks
```

Now you can install and import any Ruby Gem by prefixing it with the `@rubygems` scope.

Please note that your Rails application must be using Proscenium to take advantage of this feature.
