# before "deploy:assets:precompile", "deploy:yarn_install"
#
# namespace :deploy do
#   desc 'Run rake yarn:install'
#   task :yarn_install do
#     on roles(:web) do
#       within release_path do
#         execute("cd #{release_path} && yarn install")
#       end
#     end
#   end
# end

namespace :deploy do
  desc 'Run rake yarn:install'
  task :yarn_install do
    on roles(:web) do
      within release_path do
        execute("cd #{release_path} && yarn install")
      end
    end
  end

  before 'deploy:assets:precompile', 'deploy:yarn_install'

  namespace :assets do
    task :install_webpack do
      on roles(:app) do
        within release_path do
          with rails_env: fetch(:stage) do
            execute :yarn, 'install'
            execute :rake, 'webpacker:binstubs'
          end
        end
      end
    end

    before :precompile, 'assets:install_webpack'
  end
end

# config valid for current version and patch releases of Capistrano
lock '~> 3.12.1'
# set :rvm_type, :user
# set :rvm_ruby_version, '2.6.3'

set :application, 'ekt_library'
set :repo_url, 'git@github.com:iL53n/ekt_library.git'

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/home/deployer/ekt_library'
set :deploy_user, 'deployer'
set :passenger_restart_with_touch, true

# Default value for :linked_files is []
append :linked_files, 'config/database.yml', 'config/master.key'


# Default value for linked_dirs is []
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system', 'storage'

# after 'deploy:publishing', 'unicorn:restart'
