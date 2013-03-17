require 'rvm/capistrano'                  # Load RVM's capistrano plugin.
require 'bundler/capistrano'
require "delayed/recipes"  
set :whenever_command, "bundle exec whenever"
require "whenever/capistrano"

set :application, "in7seconds"
set :rails_env, 'production'

set :rvm_ruby_string, '1.9.3' # Or whatever env you want it to run in.

role :web, "174.129.249.0"
role :db,  "174.129.249.0", :primary => true # This is where Rails migrations will run
set :delayed_job_server_role, :web

# server details
default_run_options[:pty] = true
ssh_options[:forward_agent] = true
set :deploy_to, "/home/ubuntu/in7seconds"
set :deploy_via, :remote_cache
set :user, "ubuntu"
set :use_sudo, false
ssh_options[:forward_agent] = true

# repo details
set :scm, :git
set :repository,  "git@github.com:/rromanchuk/in7seconds.git"
set :branch, "master"


after 'deploy:update', 'deploy:cleanup'
before 'deploy:create_symlink', 'deploy:abort_if_pending_migrations'
after 'deploy:update_code' do
  run "cd #{release_path}; RAILS_ENV=production rake assets:precompile"
end
before "deploy:restart", "delayed_job:stop"
after  "deploy:restart", "delayed_job:start"
after  "deploy:restart", "deploy:ensure_alive"
after "deploy:stop",  "delayed_job:stop"
after "deploy:start", "delayed_job:start"

# tasks
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :web, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path, 'tmp', 'restart.txt')}"
  end
  task :abort_if_pending_migrations, :roles => :db, :only => { :primary => true } do
    run "cd #{release_path} && bundle exec rake RAILS_ENV=#{rails_env} db:abort_if_pending_migrations"
  end
  task :nginx, :roles => :web do
    run 'sudo /opt/nginx/sbin/nginx restart'
  end

  task :ensure_alive do 
    cmd = "curl http://in7seconds.com" 
    system(cmd) 
  end

end


