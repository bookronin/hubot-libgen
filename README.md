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
user1>> hubot libgen <query>
hubot>> The following books were found: …
```
