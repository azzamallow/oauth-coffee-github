# github ouath

Simple express app which will authenticate with github via oauth and list the repositories for the user.

## getting started

```
npm install -g supervisor coffee-script
npm install
```

You will need to create a .env file with github client details. You will need to generate an app to get these details. visit https://github.com/settings/applications and register a new application.
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

Dev mode
```
supervisor app.coffee
```

Prod mode
```
coffee app.coffee
```