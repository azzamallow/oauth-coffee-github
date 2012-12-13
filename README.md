# Web Auth

Authorise with Github. Express/Coffee style.

## Getting Started

```
npm install -g supervisor coffee-script
npm install
```

You will need to create a .env file with your github credentials.
```
vim .env
```
```
#!/bin/bash
export GITHUB_CLIENT_ID=<id>
export GITHUB_CLIENT_SECRET=<secret>
```
```
source .env
```

Now the app can be started
```
supervisor app.coffee
```