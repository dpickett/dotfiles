alias migrate="bundle exec rake db:migrate db:test:prepare"
alias remigrate="bundle exec rake db:migrate && bundle exec rake db:migrate:redo && bundle exec rake db:schema:dump db:test:prepare"
alias rollback="bundle exec rake db:rollback"
alias rbtest="ruby -Itest"
alias deploy="cap deploy"

alias ga='git add .'
alias gb='git branch -a'
alias gbtrack='git branch --track'
alias gco='git checkout'
alias gcom='git commit -a -v'
alias gems='cd /usr/local/lib/ruby/gems/1.8/gems'
alias ghead='git checkout HEAD .'
alias gmas='git checkout master'
alias gp='cd ~/gemplugins'
alias gpp='git pull && git push'
alias gstat='git status'
alias gtk='gitk --all &'
alias cleanup='git remote prune origin && git gc && git clean -dfx && git stash clear'
alias rmb='git branch -D $1 && git push origin :$1'-

alias ras='ruby script/server'

alias tl='tail -n150'
alias ls='ls -al'

alias gca='google calendar add '

alias bspec='bundle exec rspec'
alias be='bundle exec'

alias s='bundle exec rspec'

alias chromedev='open /Applications/Google\ Chrome.app --args --disable-web-security'

alias stage="git checkout staging && git merge master && git pull origin staging && git push origin staging && git pull staging master && git push staging staging:master"
alias production="git checkout production && git merge staging && git pull origin production && git push origin production && git pull production master && git push production production:master"

alias sync_notes="gnsync --path ~/Dropbox/notes --notebook 'Raw Notes' --logpath ~/geeknote.log"

note () { mvim -c "GeeknoteCreateNote $1" }
