
namespace :db_seed_from_csv do
  desc 'seed db with CSV file data'
  task csv_db_seed: :environment do

    Rake::Task['db:drop'].execute
    Rake::Task['db:create'].execute
    Rake::Task['db:migrate'].execute

  end

end
