# hubot-libgen

A hubot script to query libgen

See [`src/libgen.coffee`](src/libgen.coffee) for full documentation.

## Installation

In hubot project repo, run:

`npm install hubot-libgen --save`

Then add **hubot-libgen** to your `external-scripts.json`:

```json
[
  "hubot-libgen"
]
```

## Sample Interaction

```
user1>> hubot libgen <query> [in:<title|author|series|periodical|publisher|year|identifier|md5|extension>]
hubot>> Request transmitted, waiting for results.(Results list)
hubot>> (Results list)
```
