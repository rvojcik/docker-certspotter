# docker-certspotter
CertSpotter from SSLMate in docker

Automated build from GitHub repository using GoLang:1.10 

## Default paths
* /root/.muttrc, for mailing options
* /certspotter, base directory for certspotter
* /run.sh , main running script

## Environments variables
* `SET_NOTIFICATION_EMAIL` , email where notification is sent, default: root@localhost
* `SET_SMTP_SERVER_URL` , .muttrc compatible SMTP url, default: 127.0.0.1
* `SET_SMTP_PASS` , Password for authentification
* `SET_EMAIL_FROM`, email of notification is sent from, default: certspotter@localhost
* `SET_EMAIL_SUBJ` , subject of notification email, default: CertSpotter Report
* `SET_SLEEP_TIME` , sleep time in sleep compatible format, default: 1h
* `SET_WATCHLIST_CONTENT` , content of watchlist file, each domain is separated by semicolon ';'
* `SET_CERTSPOT_ARGS` , custom additional args for certspotter command
* `SET_MUTTRC_FILE`, custom muttrc file, useful when using ConfigMap in Kubernetes, default: /root/.muttrc
* `SET_MODE` , running mode can be daemon or onetime. Onetime is usefull for Kubernetes CronJobs, run tests and end. default: daemon

Default muttrc file is overwritten each time when run.sh is executed. So if you want use ConfigMap in Kubernetes and specify your own file use `SET_MUTTRC_FILE` to set different file for mutt to use.

For watchlist situation is different, If you don't specify `SET_WATCHLIST_CONTENT` nohing is generated, so you can use `/certspotter/watchlist` even in ConfigMap usecase.

### SMTP_URL Examples
* `smtp://10.10.10.25`, send mail using SMTP Relay server for our network
* `smtps://username@smtp.gmail.com:465`, send mail using Gmail 

When using AUTH don't forget to also set correct
* `SET_EMAIL_FROM`
* `SET_SMTP_PASS`
